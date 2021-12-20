//
//  MainMessagesView.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/20/21.
//

import SwiftUI

struct MainMessagesView: View {
    
    private var customNavBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "person.fill")
                .font(.system(size: 32, weight: .bold))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("USERNAME")
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
                    print("signout actions")
                }),
                    .cancel()
            ])
        }
    }
    
    private var newMessageButton: some View {
        Button {
            
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
    }
    
    private var messageView: some View {
        ScrollView {
            ForEach(0..<5, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 32)
                                        .stroke(Color(.label), lineWidth: 1)
                            )
                        VStack(alignment: .leading) {
                            Text("user name")
                                .font(.system(size: 16, weight: .bold))
                            Text("message send to user")
                                .font(.system(size: 14, weight: .light))
                        }
                        Spacer()
                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 5)
                }
                .padding(.horizontal)
            }
        }
    }
    
    @State var shouldShowLogoutOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                customNavBar
                messageView
            }
            .overlay(newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
