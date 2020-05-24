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
        getUserInfo()
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

    func getUserInfo(){
        if Auth.auth().currentUser != nil{
            let Eposta = Auth.auth().currentUser!.email!
            let fsDBRef = Firestore.firestore()
            fsDBRef.collection("Uyeler")
                .whereField("uyeEPosta", isEqualTo: Eposta)
                .getDocuments { (snapshot, error) in
                    if error != nil{
                        self.makeAlert(baslik: "Ups!", mesaj: error?.localizedDescription ?? "Bir şeyler ters gitti! Tekrar dene.")
                    }else{
                        if snapshot?.isEmpty ==  true || snapshot == nil{
                            self.makeAlert(baslik: "Ups", mesaj: error?.localizedDescription ?? "Bir şeyler ters gitti! Tekrar dene.")
                        }else{
                            for doc in snapshot!.documents{
                                if let currentUyePP = doc.get("uyePPImg") as? String{
                                    if let currentUyeDispName = doc.get("uyeDisplayName") as? String{
                                        if let currentUyeEPosta = doc.get("uyeEPosta") as? String{
                                            self.epostaLbl.text = currentUyeEPosta
                                            self.displayNameLbl.text = currentUyeDispName
                                            self.userPPImg.sd_setImage(with: URL(string: currentUyePP), placeholderImage: UIImage(named: "uyePPDefault"))
                                        }
                                    }
                                }
                            }
                        }//snapshot not nill
                    }//snapshot error
            }//get documents
        }//current user nil
        
    }//end of func
    
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
