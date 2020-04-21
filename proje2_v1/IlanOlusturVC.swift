//
//  IlanOlusturVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
class IlanOlusturVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //Elements
    
    @IBOutlet weak var yeniIlanImgView: UIImageView!
    @IBOutlet weak var yeniIlanIsimTxt: UITextField!
    @IBOutlet weak var yeniIlanAdresTxt: UITextField!
    @IBOutlet weak var yeniIlanTakas1Txt: UITextField!
    @IBOutlet weak var yeniIlanTakas2Txt: UITextField!
    @IBOutlet weak var yeniIlanTakas3Txt: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //klavye GR
        let klavyeGest = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(klavyeGest)
        //img picker GR
        yeniIlanImgView.isUserInteractionEnabled = true
        let resimGest = UITapGestureRecognizer(target: self, action: #selector(ImagePick))
        yeniIlanImgView.addGestureRecognizer(resimGest)
    }
    
    
    //aksiyonlar
    
    @IBAction func IlanVerBtnClicked(_ sender: Any) {       ///görsel>storage --> storage>görsel urls + data > firestore
        //-----------------------------------STORAGE UPLOAD
        
        //st ref
        
        let st = Storage.storage()
        let stRef = st.reference()
        let ilanGorselDoc = stRef.child("ilanGorselleri")
        
        //UIIMG 2 data convertion
        
        if let imgData = yeniIlanImgView.image?.jpegData(compressionQuality: 0.5){
            let imgID = UUID().uuidString
            let imgRef = ilanGorselDoc.child("\(imgID).jpeg")
            imgRef.putData(imgData, metadata: nil) { (metadata, error) in
                if error != nil{
                    self.makeAlert(baslik: "Hata", mesaj: error?.localizedDescription ?? self.StorageUnkError)
                }else{
                    imgRef.downloadURL { (url, error) in
                        if error == nil{
                            
                            //-----------------------------------FİRESTORE UPLOAD
                            
                            //doc refs
                            
                            let fireStoreDatabase = Firestore.firestore()
                            var fsRef : DocumentReference? = nil
                            
                            //data prep 4 push
                            
                            let ilanImgUrl = url?.absoluteString
                            let fsIlanDic = [
                                "ilanImgUrl" : ilanImgUrl!,
                                "ilanKullanici" : Auth.auth().currentUser!.email!,
                                "ilanIsmi" : self.yeniIlanIsimTxt.text!,
                                "ilanAdres" : self.yeniIlanAdresTxt.text!,
                                "ilanTakas1" : self.yeniIlanTakas1Txt.text!,
                                "ilanTakas2" : self.yeniIlanTakas2Txt.text!,
                                "ilanTakas3" : self.yeniIlanTakas3Txt.text!,
                                "date" : FieldValue.serverTimestamp()
                            ] as [String:Any] /*key(fsd key val):val(data val from user)*/
                            
                            //security check before push
                            
                            if Auth.auth().currentUser != nil{
                                
                                //gereklilik?
                                
                                if  self.yeniIlanIsimTxt.text == "" ||
                                    self.yeniIlanAdresTxt.text == "" ||
                                    self.yeniIlanTakas1Txt.text == "" ||
                                    self.yeniIlanTakas2Txt.text == "" ||
                                    self.yeniIlanTakas3Txt.text == "" {
                                    
                                    self.makeAlert(baslik: "Hata", mesaj: "Ürüne ait talep edilen bilgilerin tamamının doldurulması zorunludur")
                                }else{
                                    
                                    //push
                                    
                                    fsRef = fireStoreDatabase.collection("Ilanlar").addDocument(data: fsIlanDic, completion: { (databaseError) in
                                        if databaseError != nil{
                                            self.makeAlert(baslik: "Hata", mesaj: error?.localizedDescription ?? self.pushError)
                                        }else{
                                            self.makeAlert(baslik: "Tamamdır", mesaj: self.ilanUploadSuccess)
                                            //field reset
                                            self.yeniIlanImgView.image = UIImage(systemName: "plus")
                                            self.yeniIlanIsimTxt.text = ""
                                            self.yeniIlanAdresTxt.text = ""
                                            self.yeniIlanTakas1Txt.text = ""
                                            self.yeniIlanTakas2Txt.text = ""
                                            self.yeniIlanTakas3Txt.text = ""
                                            self.tabBarController?.selectedIndex = 0
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //fonksiyonlar
    
    @objc func ImagePick(){
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = false
        present(imgPicker,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        yeniIlanImgView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(){
           view.endEditing(true)
    }
    
    func makeAlert(baslik: String , mesaj: String){
        let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
        let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(OKButton)
        self.present(alert,animated: true,completion: nil)
    }

    //alert messages
    
    let StorageUnkError = "Görsel yüklenirken beklenmedik bir hata ile karşılaşıldı.Görselin iCloud saklama alanından iPhone'ununza yüklendiğinden emin olup tekrar deneyiniz."
    let cloudPullReqError = "Görsel uzak sunucudan çekilirken bir hata ile karşılaşıldı.Bu sunucu kaynaklı bir problem olabilir. Lütfen daha sonra tekrar deneyiniz"
    let pushError = "Verilerin servera yüklenmesi sırasında bir hata ile karşılaşıldı.Bu sunucu kaynaklı bir problem olabilir. Lütfen daha sonra tekrar deneyiniiz"
    let ilanUploadSuccess = "Yaşasın!Ilanın başarı ile oluşturuldu.Ilanlara göz atman için seni anasayfaya yönlendiriyoruz"
}
