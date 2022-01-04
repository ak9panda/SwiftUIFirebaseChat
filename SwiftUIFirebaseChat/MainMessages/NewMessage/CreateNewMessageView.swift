//
//  CreateNewMessageView.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/22/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessageView: View {
    
    let didSelectNewUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var newMessageVM = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let users = newMessageVM.users {
                    ForEach (users) { user in
                        Button {
                            didSelectNewUser(user)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack(spacing: 16) {
                                WebImage(url: URL(string: user.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(50)
                                    .overlay(RoundedRectangle(cornerRadius: 50)
                                                .stroke(Color(.label), lineWidth: 1))
                                Text(user.email)
                                    .foregroundColor(Color(.label))
                                Spacer()
                            }.padding(.horizontal)
                        }
                        Divider()
                            .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
//        CreateNewMessageView()
        MainMessagesView()
    }
}
