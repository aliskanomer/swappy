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
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var userPPImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImg()
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
    
    func bgImg(){
        let bg = UIImage(named: "ProfileBG")
        var bgImgView : UIImageView!
        bgImgView = UIImageView(frame: view.bounds)
        bgImgView.contentMode = .scaleAspectFill
        bgImgView.clipsToBounds = true
        bgImgView.image = bg
        bgImgView.center = view.center
        view.addSubview(bgImgView)
        self.view.sendSubviewToBack(bgImgView)
        
    }
}
