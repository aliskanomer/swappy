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
    var sUDIsim = ""
    var sUDT1 = ""
    var sUDT2 = ""
    var sUDT3 = ""
    var sUDImg = "" //url aktarıldı
    var sUDID = "" //ID aktarıldı String olarak
    //elements
    @IBOutlet weak var urunImg: UIImageView!
    @IBOutlet weak var urunısimLbl: UILabel!
    @IBOutlet weak var urunTakas1Lbl: UILabel!
    @IBOutlet weak var urunTakas2Lbl: UILabel!
    @IBOutlet weak var urunTakas3Lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urunısimLbl.text = sUDIsim
        urunTakas1Lbl.text = sUDT1
        urunTakas2Lbl.text = sUDT2
        urunTakas3Lbl.text = sUDT3
        urunImg.sd_setImage(with: URL(string: sUDImg))

    }

    @IBAction func ilanKaldırBtnClicked(_ sender: Any) {
        let db = Firestore.firestore()
        let docRef = db.collection("Ilanlar").document(self.sUDID)
        docRef.getDocument { (doc, error) in
            if error == nil{
                if let dataID = doc?.documentID {
                    if dataID == self.sUDID{
                        docRef.delete()
                    }
                }
            }
        }
        /*docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }*/
        
        
    }
    
}
