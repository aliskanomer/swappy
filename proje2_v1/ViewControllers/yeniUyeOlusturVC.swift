//
//  yeniUyeOlusturVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 3.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class yeniUyeOlusturVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//elements
    
    @IBOutlet weak var yeniUyePPImg: UIImageView!
    @IBOutlet weak var yeniUyeIsımTxt: UITextField!
    @IBOutlet weak var yeniUyeSifreTxt: UITextField!
    @IBOutlet weak var yeniUyeEmailTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Funcitons
        
        bgImg(imgName: "yeniUyeBG")
        
        //Gesture Recognizers
        
        yeniUyePPImg.isUserInteractionEnabled = true
        let PPGest = UITapGestureRecognizer(target: self, action: #selector(ImagePick))
        yeniUyePPImg.addGestureRecognizer(PPGest)
        let keyboardGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
         view.addGestureRecognizer(keyboardGR)
    }
    
    @IBAction func uyeOlBtnClicked(_ sender: Any) {
        if yeniUyeIsımTxt.text == "" || yeniUyeSifreTxt.text == "" || yeniUyeEmailTxt.text == ""{
            self.makeAlert(baslik: "Hata! ", mesaj: self.emptyFieldError)
        }else{
            Auth.auth().createUser(withEmail: yeniUyeEmailTxt.text!, password: yeniUyeSifreTxt.text!) { (signInData, error) in
                if error != nil{
                    self.makeAlert(baslik: "Hata", mesaj: error?.localizedDescription ?? "Kullanıcı Oluşturma hatası")
                }else{
                    /*Auth kayıt >>başarılıysa>> DB Kayıt >>Başarılıysa>> performSegue 2 AnaSayfa*/
                    if let newUser = signInData{
                            let sto = Storage.storage()
                            let stoRef = sto.reference()
                            let ppGorselDoc = stoRef.child("kullaniciPP")
                            
                            if let ppData = self.yeniUyePPImg.image?.jpegData(compressionQuality: 0.5){
                                let ppID = UUID().uuidString
                                let ppRef = ppGorselDoc.child("\(ppID).jpeg")
                                ppRef.putData(ppData, metadata: nil) { (metadata, error) in
                                    if error != nil{
                                        self.makeAlert(baslik: "Hata", mesaj: error?.localizedDescription ?? self.StorageUnkError)
                                    }else{
                                        ppRef.downloadURL { (url, error) in
                                            if error == nil{
                                                //firestore referances
                                                let fsDB = Firestore.firestore()
                                                var fsRef : DocumentReference? = nil
                                                //data prep
                                                let changeReq = newUser.user.createProfileChangeRequest()
                                                changeReq.displayName = self.yeniUyeIsımTxt.text!
                                                changeReq.photoURL = url
                                                changeReq.commitChanges { (error) in
                                                    if error == nil{
                                                        if let DispName = changeReq.displayName{
                                                            if let imgUrl = changeReq.photoURL{
                                                                if let email = newUser.user.email{
                                                                    if let newUseruid = newUser.user.uid as? String{
                                                                        let newMember = UyeModel(uyeDisplayName: DispName, uyeEPosta: email, uyeID: newUseruid, uyePPImg: imgUrl.absoluteString)
                                                                        let uyeDic = [
                                                                            "uyeID" : newMember.uyeID,
                                                                            "uyeEPosta" : newMember.uyeEPosta,
                                                                            "uyeSifre" : self.yeniUyeSifreTxt.text!,
                                                                            "uyeDisplayName" : newMember.uyeDisplayName,
                                                                            "uyePPImg" : newMember.uyePPImg
                                                                        ] as [String:Any]
                                                                        //push
                                                                        fsRef = fsDB.collection("Uyeler").addDocument(data: uyeDic, completion: { (DBerror) in
                                                                            if DBerror != nil{
                                                                                self.makeAlert(baslik: "Hata", mesaj: DBerror?.localizedDescription ?? self.pushError)
                                                                            }else{
                                                                                self.performSegue(withIdentifier: "uyeOlustur2AnaSf", sender: nil)
                                                                            }//push error kontrol çıkışı
                                                                        })//add dcoument completion block çıkışı
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }//changeReq completion block çıkışı
                                            }//url download error yoksa if çıkışı
                                        }//download url completion block çıkışı
                                    }//data put error else çıkışı
                                }//data put completion block çıkışı
                            }//görsel seçim if let çıkışı
                    }
                }
            }
        }//Alan boş else çıkışı
        
    }//btn_clicked çıkışı

    //selectors
    @objc func ImagePick(){
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = false
        present(imgPicker,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        yeniUyePPImg.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    @objc func hideKeyboard(){
           view.endEditing(true)
    }
    
    //Funcitons
    func bgImg(imgName: String){
        let bg = UIImage(named: imgName)
        var bgImgView : UIImageView!
        bgImgView = UIImageView(frame: view.bounds)
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.clipsToBounds = true
        bgImgView.image = bg
        bgImgView.center = view.center
        view.addSubview(bgImgView)
        self.view.sendSubviewToBack(bgImgView)
        
    }
    func makeAlert(baslik: String , mesaj: String){
           let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
           let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(OKButton)
           self.present(alert,animated: true,completion: nil)
       }
       
    //messages
    let StorageUnkError = "Görsel yüklenirken beklenmedik bir hata ile karşılaşıldı.Görselin iCloud saklama alanından iPhone'ununza yüklendiğinden emin olup tekrar deneyiniz."
    let emptyFieldError = "Tüm metin alanlarının doldurulması zorunludur"
    let pushError = "Verilerin servera yüklenmesi sırasında bir hata ile karşılaşıldı.Bu sunucu kaynaklı bir problem olabilir. Lütfen daha sonra tekrar deneyiniiz"
    let uyeSuccess = "Yaşasın! Üyelik işlemlerin tamam. Bol şanslar!"
}
