//
//  ChatVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 5.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import SDWebImage
import InputBarAccessoryView

class ChatVC: MessagesViewController,InputBarAccessoryViewDelegate,MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    
    //variables
    var ilanSahibiUye : UyeModel?
    var currentUser : User = Auth.auth().currentUser!
    var messages : [Message] = [] //[Message] message.swift dosyasında tanımlanan struct
    private var docReference : DocumentReference?
    //veriler aslında IlanGoruntule Segueden geliyor ama opsiyonelle uğraşmamak için default değerleri nill
    var recieverName : String = ""
    var recieverImg : String = ""
    var recieverID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = recieverName
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .orange
        messageInputBar.sendButton.setTitleColor(.systemPink, for: .normal)
        
        //Delegate Atamaları
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
    }
    
    //FİREBASE VE MESAJLAŞMA FONKSİYONLARI
    func createChat(){
        let users = [self.currentUser.uid, self.recieverName]
        let data: [String: Any] = [
            "users":users
        ]
        
        let db = Firestore.firestore().collection("Chats")
        db.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat()
            }
        }
    } //yeni bir konuşma başlatma
    func loadChat(){
        let db = Firestore.firestore()
            .collection("Chats")
            .whereField("users", arrayContains: Auth.auth().currentUser!.uid)
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error{
                print("Error \(error)")
                return
            }else{
                guard let queryCount = chatQuerySnap?.documents.count else{return}//Chat query ölçülerek daha önceki konuşmalara bakılır.
                if queryCount == 0{
                    self.createChat()
                }else if queryCount >= 1{
                    //konuşma geçmişinin yüklenmesi
                    for doc in chatQuerySnap!.documents{
                        let chat = Chat(dictionary: doc.data())
                        if (chat?.users.contains(self.recieverID))!{ //yalnızca takasa tıklayan kullanıcı ile olan chatlerin çekilmesi için bu if eklenir
                            self.docReference = doc.reference
                            doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true , listener: { (threadQuery, error) in
                                    if let error = error{
                                        print("Error\(error)")
                                        return
                                    }else{
                                        self.messages.removeAll()
                                        for message in threadQuery!.documents{
                                            let msg = Message(dictionary: message.data())
                                            self.messages.append(msg!) //FATAL ERROR
                                            print("Data: \(msg?.content ?? "Mesaj Bulunamadı")")
                                        }
                                        self.messagesCollectionView.reloadData()
                                        self.messagesCollectionView.scrollToBottom(animated: true)
                                    }
                            })
                            return
                        }//yalnızca takas tıklayan kullanıcı için yapılan if kontrolünün sonu
                    }//doc döngüsünü sağlayan for döngüsü sonu
                }
                self.createChat()
            }
            }
        }//Eski konuşma varsa geri yükleme
    private func insertNewMessage(_ message : Message){
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    } //yeni bir mesajı eklemek
    private func save(_ message : Message){
        let data : [String:Any] = [
            "content" : message.content,
            "created" : message.created,
            "id" : message.id,
            "senderID" : message.senderID,
            "senderName" : message.senderName,
            "senderImgUrl" : message.senderImg,
            "recieverID" : message.recieverID,
            "recieverName" : message.recieverName,
            "recieverImg" : message.recieverImg
        ]
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error{
                print("Error \(error)")
                return
            }
            self.messagesCollectionView.scrollToBottom()
        })
    }//Mesajların firebase'e kaydedilmesini sağlayan method
    
    //DELEGATE FONKSİYONLARI VE PROTOCOLLER
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let currentUserDispName =  Auth.auth().currentUser?.displayName{
            if let senderImgURL = currentUser.photoURL{
                let senderImgS = senderImgURL.absoluteString
                let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: currentUserDispName ,senderImg:senderImgS,recieverID: self.recieverID,recieverName: self.recieverName,recieverImg: self.recieverImg)
                insertNewMessage(message)
                save(message)
                //input alanının göndere tıklandıktan sonra temizlenmesi
                inputBar.inputTextView.text = ""
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }//Gönder butonuna tıklanıldığında çağırılan method
    func currentSender() -> SenderType {
        return Sender(id:Auth.auth().currentUser!.uid, displayName: currentUser.displayName ?? "Chat")
    } //SenderType Protocol CURRENT USER DİSP NAME ALMAN LAZIM
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }//MessagesCollectionView Protocol
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0{
            print("Chat geçmişi bulunamadı")
            return 0
        }else{
            return messages.count
        }
    }//MessagesCollectionView Protocol
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero //default avatar boyunun döndürülmesini sağlıyor.
    } //MessagesLayoutDelegate Protocol
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .orange: .lightGray
    } //MessageBubbleColor Protocol RENK İÇİN BAK
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {

        if message.sender.senderId == currentUser.uid{
            SDWebImageManager.shared.loadImage(with: currentUser.photoURL , options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageURL) in
                avatarView.image = image //burada image current user için çekilmeli
            }
        }else{
            SDWebImageManager.shared.loadImage(with: URL(string: recieverImg), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageURL) in
                avatarView.image = image
            }
        }
    } //CURRENT USER IMG URL ALINMALI
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    } //Mesaj bubble şekli
}

    



