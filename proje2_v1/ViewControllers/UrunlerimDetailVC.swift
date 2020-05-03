//
//  UrunlerimDetailVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 19.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class UrunlerimDetailVC: UIViewController {
   
    //data transfer variables
    var secilmisIlan : ilanModel?
    var sUDID = ""
    //elements
    @IBOutlet weak var urunImg: UIImageView!
    @IBOutlet weak var urunısimLbl: UILabel!
    @IBOutlet weak var urunTakas1Lbl: UILabel!
    @IBOutlet weak var urunTakas2Lbl: UILabel!
    @IBOutlet weak var urunTakas3Lbl: UILabel!
    @IBOutlet weak var ilanKaldırMesajLbl: UILabel!
    @IBOutlet weak var ilanUyarıMesajLbl: UILabel!
    @IBOutlet weak var kaldirBtn: UIButton!
    @IBOutlet weak var urunAdresLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let ilan = secilmisIlan{
            urunısimLbl.text = ilan.isim
            urunTakas1Lbl.text = ilan.takas1
            urunTakas2Lbl.text = ilan.takas2
            urunTakas3Lbl.text = ilan.takas3
            urunAdresLbl.text = ilan.adres
            urunImg.sd_setImage(with: URL(string: ilan.gorsel))
        }
        

    }

    @IBAction func ilanKaldırBtnClicked(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("Ilanlar").document(self.sUDID)
        docRef.getDocument { (doc, error) in
            if error == nil{
                if let dataID = doc?.documentID {
                    if dataID == self.sUDID{
                        docRef.delete()
                        //rearrange of the page by code
                        self.urunImg.isHidden = true
                        self.urunısimLbl.isHidden = true
                        self.urunTakas1Lbl.isHidden = true
                        self.urunTakas2Lbl.isHidden = true
                        self.urunTakas3Lbl.isHidden = true
                        self.ilanUyarıMesajLbl.isHidden = true
                        self.urunAdresLbl.isHidden = true
                        self.ilanKaldırMesajLbl.text = self.deleteSuccess
                        self.ilanKaldırMesajLbl.center.x = self.view.center.x
                        self.ilanKaldırMesajLbl.center.y = self.view.center.y
                        self.kaldirBtn.isHidden = true
                    }
                }
            }else{
                self.makeAlert(baslik: "Ups!", mesaj: self.deleteError)
            }
        }
        
        
    }
    func makeAlert(baslik: String , mesaj: String){
        let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
        let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(OKButton)
        self.present(alert,animated: true,completion: nil)
    }
    //messages
       let deleteSuccess = "Tamamdır! İlanını sildik. Sayfayı aşağı doğru çekerek geri dönebilrisin!"
       let deleteError = "Bir hata ile karşılaştık. Bu uzak sunucudan kaynaklı bir hata olabilir. Daha sonra tekrar dene!"
}
