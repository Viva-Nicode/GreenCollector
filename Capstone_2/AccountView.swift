//
//  AccountView.swift
//  Capstone_2
//
//  Created by Nicode . on 11/20/23.
//

import SwiftUI

struct AccountView: View {
    @State private var anyView = true
    let didCompleteLoginProcess: () -> ()
    
    
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

//#Preview {
//    AccountView()
//}
