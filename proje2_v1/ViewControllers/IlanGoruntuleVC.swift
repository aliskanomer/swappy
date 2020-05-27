//
//  IlanGoruntuleVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
class IlanGoruntuleVC: UIViewController {
    //elements
    @IBOutlet weak var IlanGorIsımLbl: UILabel!
    @IBOutlet weak var IlanGorImgView: UIImageView!
    @IBOutlet weak var IlanGorAdresLbl: UILabel!
    @IBOutlet weak var IlanGorEpostaLbl: UILabel!
    @IBOutlet weak var IlanGorTakas1Lbl: UILabel!
    @IBOutlet weak var IlanGorTakas2Lbl: UILabel!
    @IBOutlet weak var IlanGorTakas3Lbl: UILabel!
    @IBOutlet weak var takasBtn: UIButton!
    
    //variables
    var secilmisIlan : ilanModel?
    var ilanSahibi : UyeModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let ilan = secilmisIlan{
            IlanGorIsımLbl.text = ilan.isim
            IlanGorAdresLbl.text = ilan.adres
            IlanGorEpostaLbl.text = ilan.email
            IlanGorTakas1Lbl.text = ilan.takas1
            IlanGorTakas2Lbl.text = ilan.takas2
            IlanGorTakas3Lbl.text = ilan.takas3
            IlanGorImgView.sd_setImage(with: URL(string: ilan.gorsel), placeholderImage: UIImage(named: "ilanGorselDefault"))
            if ilan.email == Auth.auth().currentUser?.email{
                takasBtn.isHidden = true
            }
        }else{
            print("beepboop")
        }
        pullUyeDataFromFS()
    }
    
    func pullUyeDataFromFS(){
        if let ilan = secilmisIlan{
            let fireStoreRef = Firestore.firestore()
            fireStoreRef.collection("Uyeler")
                .whereField("uyeEPosta", isEqualTo: ilan.email).addSnapshotListener { (snapshot, snapshotError) in
                    if snapshotError != nil{
                        print("Error")
                    }else{
                        if snapshot?.isEmpty != true && snapshot != nil{
                            for doc in snapshot!.documents{
                                if let uyeName = doc.get("uyeDisplayName") as? String{
                                    if let uyeMail = doc.get("uyeEPosta") as? String{
                                        if let uyeid = doc.get("uyeID") as? String{
                                            if let uyePP = doc.get("uyePPImg") as? String{
                                                let ilanUye = UyeModel(uyeDisplayName: uyeName, uyeEPosta: uyeMail, uyeID: uyeid, uyePPImg: uyePP)
                                                self.ilanSahibi = ilanUye
                                                //snapshotta verileri aktarıyor
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }
        
    }
    
    @IBAction func ilanGorTakasBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "toChatVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatVC"{
            let destinationVC = segue.destination as! ChatVC
            if let ilanOwner = ilanSahibi{
                destinationVC.ilanSahibiUye = ilanOwner
                destinationVC.user2ImgUrl = ilanOwner.uyePPImg //"https://firebasestorage.googleapis.com/v0/b/proje2-v1.appspot.com/o/kullaniciPP%2FDF470392-D225-40FE-9A07-BB8D5E609D5A.jpeg?alt=media&token=c11b9767-7b57-459d-9876-cab48171fe8b"
                destinationVC.user2Name = ilanOwner.uyeDisplayName //"Ali Duru"
                destinationVC.user2UID = ilanOwner.uyeID //"rijGmsuQCQZNRPV71d47HgUNLg02"
            }
        }
    }
}
