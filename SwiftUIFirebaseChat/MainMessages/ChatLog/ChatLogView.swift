//
//  ChatLogView.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/24/21.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    @State var chatText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                messagesView
                VStack(spacing: 0) {
                    Spacer()
                    chatBottomBar 
                        .background(Color.white)
                }
            }
            .navigationTitle(self.chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<20, id: \.self) { num in
                HStack {
                    Spacer()
                    HStack {
                        Text("Fake Chat logs")
                            .foregroundColor(Color.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            HStack{ Spacer() }
        }
        .background(Color.init(white: 0.9))
    }
    
    private var chatBottomBar: some View {
        HStack {
            Image(systemName: "photo.on.rectangle")
                .foregroundColor(.secondary)
                .font(.system(size: 24))
            TextField("Description", text: $chatText)
            Button {
                
            } label: {
                Text("Send")
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid":"uTBRYacGsONoEHnzdLA9JxFs2As1", "email":"aakkpp@gmail.com"]))
        }
    }
}
