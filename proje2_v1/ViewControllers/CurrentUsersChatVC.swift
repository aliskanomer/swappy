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

//models
struct TWChat {
    var recieverIsim :  String
    var recieverImg : String
    var recieverID :  String
}

class CurrentUsersChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var chatTableView: UITableView!
    
    var ChatArray = [TWChat]()
    var secilenChat : TWChat?
    
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
                                                    if let id = threadDoc.get("recieverID") as?  String{
                                                        print(isim,img)
                                                        let TwData = TWChat(recieverIsim: isim, recieverImg: img, recieverID: id)
                                                        self.ChatArray.append(TwData)
                                                    }
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
        cell.chatDispName.text = ChatArray[indexPath.row].recieverIsim
        cell.charPPImg.sd_setImage(with: URL(string: ChatArray[indexPath.row].recieverID), placeholderImage: UIImage(named: "uyePPDefault"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenChat = self.ChatArray[indexPath.row]
        performSegue(withIdentifier: "myChatVCSeg", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myChatVCSeg"{
            let destVC = segue.destination as! ChatVC
            destVC.recieverName = secilenChat!.recieverIsim
            destVC.recieverImg = secilenChat!.recieverImg
            destVC.recieverID = secilenChat!.recieverID
            //karşı taraftaki user2ların burdan yollanması gerekiyor.
            //uğraş bununla
        }
    }
    func makeAlert(baslik: String , mesaj: String){
        let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
        let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(OKButton)
        self.present(alert,animated: true,completion: nil)
    }
    let DBSnapError = "Konuşmalara erişirken bir hata ile karşılaştık. Bu Server Kaynaklı bir sıkıntı olabilir. Uygulamayı kapatıp yeniden başlatmayı dene."
}
