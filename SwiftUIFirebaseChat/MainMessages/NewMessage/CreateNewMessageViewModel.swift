//
//  CreateNewMessageViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/22/21.
//

import Foundation

class CreateNewMessageViewModel: ObservableObject {

    @Published var users = [ChatUser]()
    @Published var errorMessage = ""

    init() {
        fetchAllUsers()
    }

    private func fetchAllUsers() {
        FirebaseManager.shared.firestore
            .collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }

                guard let snapShot = documentsSnapshot else {
                    self.errorMessage = "Failed to fetch users."
                    return
                }
                
                // snapshot.documents or snapshot.documentChanges in a loop produces crash
                guard let documents = (snapShot as NSObject).value(forKey: "documentChanges") as? NSArray else { return }
                
                documents.forEach { document in
                    guard let object = document as? NSObject else { debugPrint("object was nil"); return }
//                    guard let type = object.value(forKey: "type") as? Int else { debugPrint("type was nil"); return }
                    guard let docs = object.value(forKey: "document") as? NSObject else { debugPrint("document was nil"); return }
                    guard let data = docs.value(forKey: "data") as? [String: Any] else { debugPrint("data was nil"); return }
                    let user = ChatUser(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user)
                    }
                }
                
// this approach prompt the following error
///  NSArray element failed to match the Swift Array Element type Expected FIRQueryDocumentSnapshot but found FIRQueryDocumentSnapshot
//                snapShot.documents.forEach({ snapshot in
//                    let data = snapshot.data()
//                    let user = ChatUser(data: data)
//                    guard let currentUserId = FirebaseManager.shared.auth.currentUser?.uid else {
//                        return
//                    }
//                    if user.uid != currentUserId {
//                        self.users.append(.init(data: data))
//                    }
//
//                })
            }
    }
}
