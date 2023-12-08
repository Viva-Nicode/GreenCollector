//
//  LoginView.swift
//  Capstone_2
//
//  Created by Nicode . on 11/18/23.
//

import SwiftUI
import Alamofire

struct Response: Decodable{
    var requestResult:String
    var code:Int
}
struct CommonTextfieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.25))
                .cornerRadius(30)
                .frame(height:46)
            configuration
                .font(.system(size: 20))
                .padding()
        }
    }
}

struct CommonButtonStyle: ButtonStyle{
    let scaledAmount: CGFloat
    
    init(scaledAmount: CGFloat = 0.9) {
        self.scaledAmount = scaledAmount
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            Rectangle().foregroundColor(Color.blue.opacity(0.9))
                .frame(width:UIScreen.main.bounds.width * 0.85)
                .cornerRadius(30)
                .frame(height: 46)
            configuration
                .label
                .font(.system(size:23))
                .foregroundColor(.white)
        }
        .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
        .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isError = false
    @State private var errorCode = 0
    @State private var errorMessage = ""
    
    var body: some View {
        
        VStack{
            Text("Create Account").font(.system(size: 40)).frame(maxWidth: 200, alignment: .leading).padding(.trailing, 120)
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
            Button(action : createNewAccount){
                Text("submit")
            }.buttonStyle(CommonButtonStyle(scaledAmount: 0.9))
        }.alert(isPresented: $isError){
            Alert(title:Text("error code : \(errorCode)"), message: Text(errorMessage))
        }
    }
    
    private func createNewAccount(){
        if !(AccountView.isValidEmail(target: email)){
            errorMessage = "올바른 이메일 형식이 아닙니다."
            isError.toggle()
        }else if(!(8...20 ~= password.count)){
            errorMessage = "비밀번호의 길이는 8이상 20이하여야 합니다."
            isError.toggle()
        }else{
            let url = "http://15.164.100.224:8080/rest/signup"
            let params:[String:Any] = ["email":email, "password":password]
            AF.request(url,
                       method: .post,
                       parameters: params, //request body에 담김
                       encoding: JSONEncoding(options: []),
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseDecodable(of: Response.self){ response in
                switch response.result {
                case .success(let dTypes):
                    errorMessage = dTypes.requestResult
                    isError.toggle()
                case .failure(let error):
                    dump(error)
                }
            }
        }
    }
}
