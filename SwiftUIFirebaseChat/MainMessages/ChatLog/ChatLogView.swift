//
//  ChatLogView.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/24/21.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    
    @ObservedObject var vm: ChatLogViewModel
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle(self.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.count += 1
                } label: {
                    Text("Count: \(vm.count)")
                }

            }
        }
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ForEach(vm.chatMessages) { message in
                        MessageView(message: message)
                    }

                    HStack{ Spacer() }
                    .id("empty")
                }
                .onReceive(vm.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        scrollViewProxy.scrollTo("empty", anchor: .bottom)
                    }
                }
            }
        }
        .background(Color.init(white: 0.9))
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(Color.white
                                .ignoresSafeArea())
        }
    }
    
    private var chatBottomBar: some View {
        HStack {
            Image(systemName: "photo.on.rectangle")
                .foregroundColor(.secondary)
                .font(.system(size: 24))
            ZStack {
                DescriptionPlaceholder()
//                    .padding(.horizontal, 3)
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            Button {
                vm.handleSend()
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

private struct MessageView: View {
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(Color.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(.secondary)
                .font(.system(size: 18))
                .padding(.top, -2)
                .padding(.horizontal, 5)
            Spacer()
        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
//            ChatLogView(chatUser: .init(data: ["uid":"uTBRYacGsONoEHnzdLA9JxFs2As1", "email":"aakkpp@gmail.com"]))
//        }
        MainMessagesView()
    }
}
