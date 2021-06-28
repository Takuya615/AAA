//
//  ContentView.swift
//  aaa
//
//  Created by user on 2021/06/17.
//

import SwiftUI
import Firebase


struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State var push = false
    @ObservedObject private var avFoundationVM = AVFoundationVM()
    
    var body: some View {
        Group{if(self.appState.isVideoMode){
            VStack{
                HStack{
                    Button(action: {self.appState.isVideoMode = false}, label: {
                            Text("  ＜Back")
                                .font(.system(size: 20))
                    })
                    //.frame(width: 60, height: 60, alignment: .center)
                    //.padding(.readLine())
                    
                    Spacer()
                }
                
                CALayerView(caLayer: avFoundationVM.previewLayer)
            }
            
            /*
            
            //Spacer()

            ZStack(alignment: .bottom) {
                
                CALayerView(caLayer: avFoundationVM.previewLayer)

                Button(action: {
                    self.avFoundationVM.takePhoto()
                }) {
                    Image(systemName: "video")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                }
                .padding(.bottom, 100.0)
            }.onAppear {
                self.avFoundationVM.startSession()
            }.onDisappear {
                self.avFoundationVM.endSession()
            }*/

            
            //CALayerView(caLayer: avFoundationVM.previewLayer)
            //VideoUIView(presenter: SimpleVideoCapturePresenter())
                //Text("ほんとはカメラが表示されるようにしたい")
            }else{
                ZStack{
                    fragment
                    fab
                }
            }
        }
    }
    var fragment:some View {
        TabView {
            FirstView()
             .tabItem {
                Image(systemName: "homekit")
                Text("ホーム")
              }
            SecondView()
            .tabItem {
                Image(systemName: "applelogo")
                Text("動画リスト")
              }
            ThirdView()
             .tabItem {
                 Image(systemName: "pencil")
                 Text("？？？")
               }
        }
    }
    
    var fab: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action:{
                    self.appState.isVideoMode = true
                }, label: {
                    Image(systemName: "video.fill.badge.plus")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                })
                .frame(width: 60, height: 60, alignment: .center)
                .background(Color.blue)
                .cornerRadius(30.0)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 60.0, trailing: 16.0))
                                
                
            }
        }
    
        
    }
    
    
}

struct FirstView: View {
    @EnvironmentObject var appState: AppState
    @State var isOpenSideMenu = false
    var body: some View {
        NavigationView{
            List {ForEach(0..<5) { (index) in
                    Text("Row \(index)")
                 }
            }
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button(action: {}) {
                            Text("設定")
                            Image(systemName: "gearshape")
                                            }
                        
                        Button(action: {
                            appState.logout()
                                
                        }) {
                            Text("ログアウト")
                            Image(systemName: "person")
                                            }
                        
                        Button(action: {}) {
                            Text("プライバシーポリシー")
                            Image(systemName: "shield")
                                            }
                    }label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
            
        }
        /*SideMenuView(isOpen: $isOpenSideMenu)
            .edgesIgnoringSafeArea(.all)
        }*/
    }
}

struct SecondView: View{
    struct Videos: Identifiable {
        var id = UUID()     // ユニークなIDを自動で設定¥
        var date: String
        var url: String
    }
    @State var videos:[Videos] = []
    
    var body: some View {
        NavigationView{
            List{
                ForEach(videos) {video in
                    Text(video.date)
                        .contentShape(RoundedRectangle(cornerRadius: 5))
                        .onTapGesture {print("タップされました\(video.date)")}
                }.onDelete(perform: delete)
            }
            .onAppear(perform: VideoList)//リストの更新をここでできる
            .navigationTitle("ビデオリスト")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    // FireBaseから、動画のデータを取り出し　リストかする
    func VideoList() {
        videos = []//reset
        let uid = String(Auth.auth().currentUser!.uid)//uidの設定
        let db = Firestore.firestore()
        db.collection(uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let date = document.data()["date"]
                    //print("日付　\(String(describing: date as? String))")
                    let url = document.data()["url"]
                    //print("リンクは\(String(describing: url as? String)) です")
                    videos.append(Videos(date: (date as? String)!, url: (url as? String)!))
                
                }
            }
        }
    }
    func delete(at offsets: IndexSet){
        let selectDate = offsets.map{ self.videos[$0].date }[0]
        print("削除するデータは\(selectDate)")
        
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        db.collection(uid!).document(selectDate).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("項目の削除成功　Document successfully removed!")
                let storageRef = Storage.storage().reference()
                let desertRef = storageRef.child("\(uid!) /\(selectDate).mp4")
                desertRef.delete { error in
                  if let error = error {
                    print("動画の削除　しっぱい\(error)")
                    // Uh-oh, an error occurred!
                  } else {
                    // File deleted successfully
                    print("動画の削除も　せいこう！")
                  }
                }
                
            }
        }
        videos.remove(atOffsets: offsets)
        
    }
    
    
}
    
struct ThirdView: View {
    var body: some View {
        NavigationView{
            Text("ただいま工事中")
            .navigationTitle("？？？")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}
/*
struct SideMenuView: View {
    @Binding var isOpen: Bool
    let width: CGFloat = 240
    var body: some View {
        ZStack {
            // 背景部分
            GeometryReader { geometry in
                EmptyView()
            }
            .background(Color.gray.opacity(0.3))
            .opacity(self.isOpen ? 1.0 : 0.0)
            .opacity(1.0)
            .animation(.easeIn(duration: 0.25))
            .onTapGesture {
                self.isOpen = false
            }

            // Todo: ここにリスト部分を実装する
            HStack {
                VStack() {
                    //Text("asdfgfdsa")
                    SideMenuContentView(topPadding:50,systemName: "gear", text: "設定")
                    SideMenuContentView(systemName: "person", text:"ログアウト")
                    SideMenuContentView(systemName: "bookmark", text: "プライバシーポリシー")
                    
                    Spacer()
                }
                    .frame(width: width)
                    .background(Color(UIColor.systemGray6))
                    .offset(x: self.isOpen ? 0 : -self.width)
                    .animation(.easeIn(duration: 0.25))
                    Spacer()
            }
        }
    }
}


struct SideMenuContentView: View {
    let topPadding: CGFloat
    let systemName: String
    let text: String
    @EnvironmentObject var appState: AppState
    //コンストラクタ
    init(topPadding: CGFloat = 30, systemName: String, text: String) {
        self.topPadding = topPadding
        self.systemName = systemName
        self.text = text
    }

    var body: some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(.gray)
                .imageScale(.large)
                .frame(width: 32.0)
            Button(action: {
                appState.isLogin = false
                //UserDefaults.standard.set(false, forKey: "login")
            }, label: {
                Text(text)
                    .foregroundColor(.gray)
                    .font(.headline)
            })
            
                
            Spacer()
        }
        .padding(.top, topPadding)
        .padding(.leading, 32)
    }
}
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.environmentObject(AppState())
    }
}
