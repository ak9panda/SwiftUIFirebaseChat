//
//  FirebaseManager.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/14/21.
//

import Foundation
import Firebase

class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}
