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
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    
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
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let img = self.image {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(80)
                                }else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color(.label), lineWidth: 1))
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
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
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
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "failed to save image to storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "failed to retrieve download image url: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                guard let imgURL = url else { return }
                storeUserInformation(imageProfileURL: imgURL)
            }
        }
        
        
    }
    
    private func storeUserInformation(imageProfileURL: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["uid": uid, "email": self.email, "profileImageUrl": imageProfileURL.absoluteString]
        FirebaseManager.shared.firestore.collection("users").document(uid)
            .setData(userData) { error in
                if let err = error {
                   print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
