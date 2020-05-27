//
//  CurrentUsersChatVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 27.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
struct TWChat {
    var chatIsim :  String
    var chatImg : String
}

class CurrentUsersChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var chatTableView: UITableView!

    var ChatArray = [TWChat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view.
        getChat()
    }
    
    func getChat(){
        let fsDB = Firestore.firestore()
        if let currentuserID = Auth.auth().currentUser?.uid{
            fsDB.collection("Chats").getDocuments{ (chatSnap, error) in
                if chatSnap != nil{
                    for chatDoc  in chatSnap!.documents{
                        if let chatData = Chat(dictionary: chatDoc.data()){ //chat modelden bir nesne yaratıp içine firebase Chatteki user dizisini atıyor ve chat IDsini
                            if chatData.users.contains(currentuserID){
                                let threadRef = chatDoc.reference
                                threadRef.collection("thread").order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true ,listener: { (threadQuery, error) in
                                    if error == nil{
                                        self.ChatArray.removeAll(keepingCapacity: false)
                                        for threadDoc in threadQuery!.documents{
                                            if let isim = threadDoc.get("recieverName") as? String{
                                                if let img = threadDoc.get("recieverImg") as? String{
                                                    print(isim,img)
                                                    let TwData = TWChat(chatIsim: isim, chatImg: img)
                                                    self.ChatArray.append(TwData)
                                                }
                                            }
                                        }
                                        self.chatTableView.reloadData()
                                    }
                                })//Thread SnapShot Listener Çıkışı
                            }//user contains çıkışı
                        }//chat if let çıkışı
                    }//chatSnap.doc for exit
                }//Snap error kontrol
                
            }
        }
    }//loadChat func bitimi

    
    
    //TableView Protocols & Segue
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(ChatArray.count)
        return ChatArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.chatDispName.text = ChatArray[indexPath.row].chatIsim
        cell.charPPImg.sd_setImage(with: URL(string: ChatArray[indexPath.row].chatImg), placeholderImage: UIImage(named: "uyePPDefault"))
        return cell
    }
    
    func makeAlert(baslik: String , mesaj: String){
        let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
        let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(OKButton)
        self.present(alert,animated: true,completion: nil)
    }
    let DBSnapError = "Konuşmalara erişirken bir hata ile karşılaştık. Bu Server Kaynaklı bir sıkıntı olabilir. Uygulamayı kapatıp yeniden başlatmayı dene."
}





    
  
    /*  if let currentUserID = Auth.auth().currentUser?.uid{
        print(currentUserID)
        let db = Firestore.firestore().collection("Chats")
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error{
                print("Error \(error)")
                return
            }else{
                db.whereField("users", arrayContains: currentUserID).getDocuments { (chatQuery, error) in
                    if error == nil{
                        guard let queryCount = chatQuery?.documents.count else{return}
                        if queryCount == 0{
                            //konuşmanın olmaması durumu
                            //self.chatIsimArray.removeAll(keepingCapacity: false) //???
                        }else if queryCount >= 1{
                            //konuşma geçmişinin yüklenmesi
                            for doc in chatQuery!.documents{
                                let chat = Chat(dictionary: doc.data())
                                if (chat?.users.contains(currentUserID))!{
                                    self.docReference = doc.reference
                                    doc.reference.collection("thread")
                                        .order(by: "created", descending: false)
                                        .addSnapshotListener(includeMetadataChanges: true , listener: { (threadQuery, error) in
                                            if let error = error{
                                                print("Error\(error.localizedDescription)")
                                                return
                                            }else{
                                                for konusma in threadQuery!.documents{
                                                    if let isim = konusma.get("senderName") as? String{
                                                        if let imgString = konusma.get("senderImgUrl") as? String{
                                                            print(isim)
                                                            self.chatIsimArray.append(isim)
                                                            self.chatImgArray.append(imgString)
                                                        }
                                                    }
                                                }//ChatArray Append for çıkışı
                                            }//Thread SnapshotListener error kontrol
                                    })//Thread SnapshotListeneer completion
                                    return
                                }//yalnızca takas tıklayan kullanıcı için yapılan if kontrolünün sonu
                            }//doc döngüsünü sağlayan for döngüsü sonu
                        }//query count >=1 kontrol
                    }else{
                        print(error?.localizedDescription)
                    }//userFiel Error Kontrol
                }//Chat field Error Kontrol
            }//query count = 0 kontrol
        }//get doc completion
    }//if let currentUserID
*/
