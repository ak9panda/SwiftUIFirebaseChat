//
//  MainMessagesViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/21/21.
//

import Foundation

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init() {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapShot, err in
            if let error = err {
                self.errorMessage = "error in getting snapshot: \(error)"
                return
            }
            
            guard let data = snapShot?.data() else {
                self.errorMessage = "No data found"
                return
            }
            
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
            self.chatUser = ChatUser(uid: uid, email: email, profileImageUrl: profileImageUrl)
        }
    }
}
