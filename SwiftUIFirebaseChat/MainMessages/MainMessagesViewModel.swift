//
//  MainMessagesViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/21/21.
//

import Foundation
import FirebaseFirestoreSwift

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isCurrentlyLoggedOut = false
    @Published var recentMessages = [RecentMessage]()
    
    init() {
        
        DispatchQueue.main.async {
            self.isCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
        fetchRecentMessages()
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .getDocument { snapShot, err in
            if let error = err {
                self.errorMessage = "error in getting snapshot: \(error)"
                return
            }
            
            guard let data = snapShot?.data() else {
                self.errorMessage = "No data found"
                return
            }
            
            self.chatUser = .init(data: data)
        }
    }
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let err = error {
                    self.errorMessage = "failed to listen for recent messages: \(err)"
                    return
                }
                
                guard let snapshot = querySnapshot else { return }
                
//                guard let documents = (snapshot as NSObject).value(forKey: "documentChanges") as? NSArray else { return }
//
//                documents.forEach { document in
//                    guard let object = document as? NSObject else { return }
//                    guard let docs = object.value(forKey: "document") as? NSObject else { debugPrint("document was nil"); return }
//                    guard let data = docs.value(forKey: "data") as? [String: Any] else { debugPrint("data was nil"); return }
//
//                    let docId = docs.value(forKey: "documentID") as? String
//                    if let index = self.recentMessages.firstIndex(where: { rm in
//                        return rm.documentId == docId
//                    }) {
//                        self.recentMessages.remove(at: index)
//                    }
//                    self.recentMessages.insert(.init(documentId: docId ?? "", data: data), at: 0)
//                }
                
                
                snapshot.documentChanges.forEach { change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: RecentMessage.self) {
                            self.recentMessages.insert(rm, at: 0)
                        }
                    }catch {
                        print("error encoding")
                    }
//                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                }
            }
    }
    
    func handleSignOut() {
        isCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}
