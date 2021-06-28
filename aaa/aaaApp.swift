//
//  aaaApp.swift
//  aaa
//
//  Created by user on 2021/06/17.
//

import SwiftUI
import Firebase

@main
struct aaaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AppState())
            //ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
    
    // 必要に応じて処理を追加
}

class AppState: ObservableObject {
    @Published var isLogin = false
    @Published var isVideoMode = false
    
    init() {
        if Auth.auth().currentUser != nil {
            self.isLogin = true
        }
    }
    
    func signup(email:String, password:String){//email:String,password:String
        
        if(email.isEmpty || password.isEmpty){

            print("No mailAdrress or password")

        }else{
            Auth.auth().createUser(withEmail: email, password: password) { [weak self]authResult, error in
                guard self != nil else { return }
                print("登録メアドは\(email)")
                print("登録パスワードは\(password)")
                if authResult != nil && error == nil{
                    self?.isLogin = true
                    print("アカウント作成に成功しました")
                }else{
                    self?.isLogin = false
                    print("アカウント作成失敗")
                }
            }
        }
        
    }
    
    
    func loginMethod(email:String, password:String){
        if(email.isEmpty || password.isEmpty){
            print("No mailAdrress or password")
      
        }else{
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
                print("ログインメルアドは\(email)")
                print("ログインパスワードは\(password)")
                if error == nil{
                    
                    print("ログインに成功しました")
                    self?.isLogin = true
               
                }else{
                    print("ログイン失敗")
                    self?.isLogin = false
                }
                //self?.appState.isLogin = true
            }
        }
    }
    
    func logout(){
        do {
          try Auth.auth().signOut()
            print("ログアウトしました")
            self.isLogin = false
        } catch let signOutError as NSError {
          print ("ログアウトできてませんError signing out: %@", signOutError)
          //UserDefaults.standard.set({true}, forKey:"login")
        }
    }
    
}

