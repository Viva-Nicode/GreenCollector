//
//  AccountView.swift
//  Capstone_2
//
//  Created by Nicode . on 11/20/23.
//

import SwiftUI

struct AccountView: View {
    @State private var anyView = true
    let didCompleteLoginProcess: (String) -> ()
    
    public static func isValidEmail(target:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: target)
    }
    
    var body: some View {
        if anyView {
            LoginView(didCompleteLoginProcess: self.didCompleteLoginProcess)
        }else{
            SignUpView()
        }
        VStack{
            Button(action:viewChange){
                if anyView{
                    Text("not a member?")
                        .frame(maxWidth:.infinity, alignment:.trailing)
                        .padding(.trailing, 30)
                }else{
                    Text("already member").frame(alignment:.trailing)
                        .frame(maxWidth:.infinity, alignment:.trailing)
                        .padding(.trailing, 30)
                }
            }.padding(.top, 5)
        }
    }
    
    private func viewChange(){
        anyView.toggle()
    }
}
