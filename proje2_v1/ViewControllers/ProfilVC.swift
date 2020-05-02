//
//  ProfilVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
class ProfilVC: UIViewController {
    @IBOutlet weak var epostaLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        epostaLbl.text = Auth.auth().currentUser?.email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cikisBtnClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "cikisYapSegue", sender: nil)
        } catch  {
            //firebase signout error handling araştır
            print("Error")
        }
    }
}
