//
//  ChatVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 5.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import MessageKit


class ChatVC: MessagesViewController{
    
    var ilanSahibiUye : UyeModel? //üyeye ait veriler ilan görüntüle içerisinden buraya prepare for segue ile aktarıldı. Uye modelin de ki tüm verilere ulaşılabiliyor.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }



}
