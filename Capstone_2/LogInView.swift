//
//  LogInView.swift
//  Capstone_2
//
//  Created by Nicode . on 11/19/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isError = false
    @State private var errorCode = 0
    @State private var errorMessage = ""
    let didCompleteLoginProcess: () -> ()
    
    var body: some View {
        
        VStack{
            Text("Sign In").font(.system(size: 40)).frame(maxWidth: 200, alignment: .leading).padding(.trailing, 120)
            TextField("", text : $email, prompt: Text("Email")
                .font(.system(size: 20))
                .foregroundColor(.blue.opacity(0.3)))
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .textFieldStyle(CommonTextfieldStyle())
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .font(.system(size:10))
            Spacer().frame(height:10)
            SecureField("", text : $password, prompt: Text("Password")
                .font(.system(size: 20))
                .foregroundColor(.blue.opacity(0.3)))
            .textFieldStyle(CommonTextfieldStyle())
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .font(.system(size:22))
            Spacer().frame(height:30)
            Button(action : signIn){
                Text("Join")
            }.buttonStyle(CommonButtonStyle(scaledAmount: 0.9))
        }.alert(isPresented: $isError){
            Alert(title:Text("error code : \(errorCode)"), message: Text(errorMessage))
        }
    }
    
    private func signIn(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, error in
            if let err = error as NSError?{
                print(err.code)
                print(err.localizedDescription)
                isError.toggle()
                errorCode = err.code
                errorMessage = err.localizedDescription
                return
            }
            self.didCompleteLoginProcess()
            print("login success")
        }
        
    }
}
