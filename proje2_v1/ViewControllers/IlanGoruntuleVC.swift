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
    
    //data Transfer variables (4_nill_handling)
    var sAdres = ""
    var sIsim = ""
    var sEposta = ""
    var sT1 = ""
    var sT2 = ""
    var sT3 = ""
    var sImg = "" //URL GELDİ
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IlanGorIsımLbl.text = sIsim
        IlanGorAdresLbl.text = sAdres
        IlanGorEpostaLbl.text = sEposta
        IlanGorTakas1Lbl.text = sT1
        IlanGorTakas2Lbl.text = sT2
        IlanGorTakas3Lbl.text = sT3
        IlanGorImgView.sd_setImage(with: URL(string: sImg))//URLden img set ediliyor
            if sEposta == Auth.auth().currentUser?.email{
                takasBtn.isHidden = true
            }
    }
    
    @IBAction func ilanGorTakasBtnClicked(_ sender: Any) {
        //mesajlaşma sayfasına segue?
    }
    


}
