//
//  ChatLogViewModel.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 1/4/22.
//

import Foundation
import Firebase

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
}

class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var count = 0
    @Published var chatMessages = [ChatMessage]()
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let err = error {
                    self.errorMessage = "Failed to listen for messages: \(err)"
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
            }
        
        // for scroll down to last message in messsage view
        DispatchQueue.main.async {
            self.count += 1
        }
    }
    
    func handleSend() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        
        let senderDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: chatText, "timestamp": Timestamp()] as [String: Any]
        
        senderDocument.setData(messageData) { error in
            if let err = error {
                self.errorMessage = "Failed to save messages to firestore: \(err)"
                return
            }
            
            self.chatText = ""
            // for scroll down to last message in messsage view after send a message
            self.count += 1
        }
        
        let recipientDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recipientDocument.setData(messageData) { error in
            if let err = error {
                self.errorMessage = "Failed to save messages to firestore: \(err)"
                return
            }
        }
    }
}
