//
//  MainMessagesView.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/20/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainMessagesView: View {
    
    @State var shouldShowLogoutOptions = false
    @State var shouldShowNewMessageScreen = false
    @State var chatUser: ChatUser?
    @State var shouldNavigatetoChatLogView = false
    
    @ObservedObject private var messageVM = MainMessagesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messageView
                
                NavigationLink("", isActive: $shouldNavigatetoChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
            .overlay(newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 10) {
            
            WebImage(url: URL(string: messageVM.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(44)
                .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.label), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 4) {
                let userName = messageVM.chatUser?.email.components(separatedBy: "@").first ?? ""
                Text(userName)
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.green)
                    Text("online")
                        .font(.system(size: 12, weight: .light))
                }
            }
            Spacer()
            Button {
                shouldShowLogoutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogoutOptions) {
            .init(title: Text("Settings"), message: Text("Logout Setting"), buttons: [
                .destructive(Text("Sign out"), action: {
                    messageVM.handleSignOut()
                }),
                    .cancel()
            ])
        }
        .fullScreenCover(isPresented: $messageVM.isCurrentlyLoggedOut, onDismiss: nil) {
            LoginView {
                self.messageVM.isCurrentlyLoggedOut = false
                self.messageVM.fetchCurrentUser()
            }
        }
    }
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(32)
            .padding()
            .shadow(radius: 8)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen, onDismiss: nil) {
            CreateNewMessageView { user in
                self.shouldNavigatetoChatLogView.toggle()
                self.chatUser = user
            }
        }
    }
    
    private var messageView: some View {
        ScrollView {
            if let recentMessages = messageVM.recentMessages {
                ForEach(recentMessages) { recentMessage in
                    VStack {
                        NavigationLink {
                            ChatLogView(chatUser: self.chatUser)
                        } label: {
                            HStack(spacing: 16) {
                                WebImage(url: URL(string: recentMessage.profileImageURL))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipped()
                                    .cornerRadius(64)
                                    .overlay(RoundedRectangle(cornerRadius: 64)
                                                .stroke(Color.black, lineWidth: 1))
                                    .shadow(radius: 2)
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recentMessage.email)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(.label))
                                    Text(recentMessage.text)
                                        .font(.system(size: 14, weight: .light))
                                        .foregroundColor(Color(.darkGray))
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                Text("1d")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        Divider()
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
