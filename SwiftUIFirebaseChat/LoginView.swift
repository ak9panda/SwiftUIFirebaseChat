//
//  ContentView.swift
//  SwiftUIFirebaseChat
//
//  Created by Aung Kyaw Phyo on 12/14/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var loginStatusMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 12) {
                    Picker(selection: $isLoginMode, label: Text("Picker Here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color.white)
                    
                    
                    Button {
                        handleAuthBtnAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(Color.white)
                                .padding(16)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                    }
                    .background(Color.blue)
                    
                    Text(loginStatusMessage)
                        .foregroundColor(Color.red)
                }
                .padding()
            }
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
            .navigationTitle(isLoginMode ? "Log in" : "Create Account")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleAuthBtnAction() {
        if isLoginMode {
            loginUser()
        }else {
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                self.loginStatusMessage = "Failed to logged in a user: \(err)"
                return
            }
            self.loginStatusMessage = "Successfully logged in a user: \(result?.user.uid ?? "")"
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            self.loginStatusMessage = "Successfully create user: \(result?.user.uid ?? "")"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
