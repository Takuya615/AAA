//
//  LoginView.swift
//  aaa
//
//  Created by user on 2021/06/17.
//

import SwiftUI
//import Firebase

struct LoginView: View {
  
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var poricy = false
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("メールアドレス", text: $email)
                        .font(.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        /*TextField("パスワード", text: $password)
                                    .font(.title)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.alphabet)*/
                SecureField("パスワードを入力してください。", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title)
                    .keyboardType(.alphabet)
                    .padding(.bottom)
                        
                HStack{
                    Spacer()
                    Button(action: {poricy.toggle()}, label: {
                        Text("プライバシーポリシー")
                    })
                    .padding(.bottom)
                    .frame(height: 20.0)
                }.padding([.bottom, .trailing])
                        
                HStack{
                    Button(action: {
                        appState.signup(email: email, password: password)
                    },
                           label: {Text("アカウント作成")
                    })
                    Spacer()
                    Button(action: {
                        appState.loginMethod(email: email, password: password)
                    },
                           label: {Text("ログイン")})
                }.padding(.trailing)
                    
            }.padding(.all)
        
        }
    
    }
    
    

}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            //.environmentObject(AppState())
    }
}
