//
//  ProfilVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class ProfilVC: UIViewController {
    @IBOutlet weak var epostaLbl: UILabel!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var userPPImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bgImg()
        if let currentUser = Auth.auth().currentUser{ //opsiyonel kaldırma
            displayNameLbl.text = currentUser.displayName
            epostaLbl.text = currentUser.email
            userPPImg.sd_setImage(with: currentUser.photoURL, placeholderImage: UIImage(named: "uyePPDefault") )
        }
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
    
    //functions
    func makeAlert(baslik: String , mesaj: String){
           let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
           let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(OKButton)
           self.present(alert,animated: true,completion: nil)
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
