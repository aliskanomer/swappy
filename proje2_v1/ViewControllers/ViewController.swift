//
//  ViewController.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var sifreTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImg()
        let klavyeGest = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(klavyeGest)
    }

    @IBAction func girisBtnClicked(_ sender: Any) {
        if emailTxt.text != "" || sifreTxt.text != ""{
            Auth.auth().signIn(withEmail: emailTxt.text!, password: sifreTxt.text!) { (logInData, error) in
                if error != nil{
                    self.makeAlert(baslik: "Hata", mesaj: error?.localizedDescription ?? "Giris Yapılamadı")
                }else{
                    self.performSegue(withIdentifier: "toAnaSayfaVC", sender: nil)
                }
            }
        }else{
            makeAlert(baslik: "Hata", mesaj: "E-posta ve/veya şifre alanları boş bırakılamaz")
        }
    }
    
    @IBAction func uyeOlBtnClicked(_ sender: Any) {
        if emailTxt.text != "" || sifreTxt.text != ""{
            Auth.auth().createUser(withEmail: emailTxt.text!, password: sifreTxt.text!) { (signInData, error) in
                if error != nil{
                    self.makeAlert(baslik: "Hata", mesaj: error?.localizedDescription ?? "Kullanıcı Giriş hatası")
                }else{
                    self.performSegue(withIdentifier: "toAnaSayfaVC", sender: nil)
                }
            }
        }else{
            makeAlert(baslik: "Hata", mesaj: "E-posta ve/veya şifre alanları boş bırakılamaz")
        }
    }
    
    func makeAlert(baslik: String , mesaj: String){
           let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
           let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(OKButton)
           self.present(alert,animated: true,completion: nil)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    func bgImg(){
        let bg = UIImage(named: "splashPageBG")
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

