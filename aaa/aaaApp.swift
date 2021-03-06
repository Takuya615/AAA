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

class DataCounter: ObservableObject {
    // Key
    let totalDay = "totalDay"
    let continuedDay = "cDay"
    let continuedWeek = "wDay"
    let retry = "retry"
    let _LastTimeDay = "LastTimeDay"

    //let calender = "Calender"
    //let firstDay = "FirstDay"
    
    //UserDefaults.standard.set(true, forKey: "isLoggedIn")//値の書き込み
    //let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")//値の読み取り

    //日時の差分を計算するメソッド
    func scoreCounter(){
        let totalDay = UserDefaults.standard.integer(forKey: self.totalDay)
        UserDefaults.standard.set(totalDay + 1, forKey: self.totalDay)
        
        let today = Date()
        let LastTimeDay: Date? = UserDefaults.standard.object(forKey: self._LastTimeDay) as? Date
    
        if LastTimeDay == nil{
            print("記念すべき第一回目")
            
            UserDefaults.standard.set( 1, forKey: self.continuedDay)//値の書き込み
            UserDefaults.standard.set(today, forKey: self._LastTimeDay)//値の書き込み
            return
        }
        
        //let day1DaysAgo = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        print("today:\(today)") //t
        //print("day3DaysAgo:\(day1DaysAgo)") //day3DaysAgo:2021-03-05 02:44:45 +0000
        print("LastTimeDay:\(LastTimeDay!)")
                            
                    
        let cal = Calendar(identifier: .gregorian)
        let todayDC = Calendar.current.dateComponents([.year, .month,.day], from: today)
        let lastDC = Calendar.current.dateComponents([.year, .month,.day], from: LastTimeDay!)
        let diff = cal.dateComponents([.day], from: lastDC, to: todayDC)
        print("todayDC:\(todayDC)")
        print("dt1DC:\(lastDC)")
        print("差は \(diff.day!) 日")
                
        
        //var calenderList:[ Int] = UserDefaults.standard.object(forKey: self.calender) as? [Int] ?? []//値が無ければ空のリスト
        let continuedDay = UserDefaults.standard.integer(forKey: self.continuedDay)
        let retry = UserDefaults.standard.integer(forKey: self.retry)
        if diff.day == 0{
            print("デイリーそのまま")
        }else if(diff.day == 1){
            print("毎日記録更新")
            UserDefaults.standard.set(continuedDay + 1, forKey: self.continuedDay)//値の書き込み
        }else{
            print("記録リセット")
            UserDefaults.standard.set(0, forKey: self.continuedDay)//値の書き込み
            UserDefaults.standard.set(retry + 1, forKey: self.retry)//値の書き込み
        }
    
        UserDefaults.standard.set(today, forKey: self._LastTimeDay)//値の書き込み

        //連続週数　前回に日曜日より６日前に1度でもHIItしたか
        
        
        
    }
    
}

class AppState: ObservableObject {
    @Published var isLogin = false
    @Published var isVideoMode = false
    @Published var isVideoPlayer = false
    @Published var playUrl = ""
    
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

