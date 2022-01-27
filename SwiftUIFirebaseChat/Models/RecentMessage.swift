//
//  RecentMessage.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 1/6/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
}

//struct RecentMessage: Identifiable {
//
//    var id: String { documentId }
//
//    let documentId: String
//    let text, email: String
//    let fromId, toId: String
//    let profileImageURL: String
//    let timestamp: Timestamp
//
//    init(documentId: String, data: [String: Any]) {
//        self.documentId = documentId
//        self.email = data[FirebaseConstants.email] as? String ?? ""
//        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
//        self.toId = data[FirebaseConstants.toId] as? String ?? ""
//        self.profileImageURL = data[FirebaseConstants.profileImageUrl] as? String ?? ""
//        self.text = data[FirebaseConstants.text] as? String ?? ""
//        self.timestamp = data[FirebaseConstants.timestamp] as? Timestamp ?? Timestamp(date: Date())
//    }
//}
