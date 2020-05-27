//
//  CurrentUsersChatVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 27.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase

class CurrentUsersChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var chatTableView: UITableView!
    private var docReference : DocumentReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view.
        loadChat()
    }
    
    func loadChat(){
        if let currentUserID = Auth.auth().currentUser?.uid{
            let db = Firestore.firestore()
                .collection("Chats")
                .whereField("users", arrayContains: Auth.auth().currentUser!.uid)
            db.getDocuments { (chatQuerySnap, error) in
                if let error = error{
                    print("Error \(error)")
                    return
                }else{
                    guard let queryCount = chatQuerySnap?.documents.count else{return}
                    if queryCount == 0{
                        //konuşmanın olmaması durumu
                        //tableview data count = 0 set edilmeli
                    }else if queryCount >= 1{
                        //konuşma geçmişinin yüklenmesi
                        for doc in chatQuerySnap!.documents{
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
                                                    //tableView'a yazılacak
                                                    //Chatte görsel kaydedilmemiş 
                                                }
                                            }
                                        }
                                })
                                return
                            }//yalnızca takas tıklayan kullanıcı için yapılan if kontrolünün sonu
                        }//doc döngüsünü sağlayan for döngüsü sonu
                    }//query count >=1 kontrol
                }//query count = 0 kontrol
            }//get doc completion
        }//if let currentUserID
    }//loadChat func bitimi

    
    
    //TableView Protocols & Segue
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.chatDispName.text = Auth.auth().currentUser?.uid
        return cell
    }

}
