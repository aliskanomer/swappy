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
    var sUDImg = ""
    
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
        //verileri çek
        //documantIDsi yollanan veri ile eşleşen veriyi sil
    }
    
}
