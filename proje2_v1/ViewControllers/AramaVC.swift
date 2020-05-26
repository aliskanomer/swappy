//
//  AramaVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class AramaVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //elements
    
    @IBOutlet weak var AramaLbl: UILabel!
    @IBOutlet weak var AramaTxt: UITextField!
    @IBOutlet weak var aramTableview: UITableView!
    @IBOutlet weak var sonucDetayLbl: UILabel!

    var ilanArray = [ilanModel]()
    var arananIlan : ilanModel?

    override func viewWillAppear(_ animated: Bool) {
        aramTableview.isHidden = true
        sonucDetayLbl.isHidden = true
        AramaTxt.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        aramTableview.delegate = self
        aramTableview.dataSource = self
        aramTableview.isHidden = true
        sonucDetayLbl.isHidden = true
    }
    
    @IBAction func AraBtnClicked(_ sender: Any) {
        if AramaTxt.text == "" {
            makeAlert(baslik: "Ups!", mesaj: TxtBarError)
        }else{
            aramTableview.isHidden = true
            sonucDetayLbl.isHidden = false
            sonucDetayLbl.text = urunBulunamadıMsg
            dataPull4Search()
            aramTableview.reloadData()
        }
    }
    
    func dataPull4Search(){
        if AramaTxt.text != ""{
            
            let FireStoreRef = Firestore.firestore()
            
            FireStoreRef.collection("Ilanlar")
                .whereField("ilanIsmi", isEqualTo: AramaTxt.text!)
                .order(by: "date", descending: true)
                .addSnapshotListener { (snapshot, snapshotError) in
                    if snapshotError != nil{
                        print("Error")//herhangi bi ürün bulamadığında da buraya giriyor filtrete uymayan ürünlere bakınca da buraya giriyo
                    }else{
                        if snapshot?.isEmpty != true && snapshot != nil{
                            self.ilanArray.removeAll(keepingCapacity: false)
                            self.aramTableview.isHidden = false
                            
                            for doc in snapshot!.documents{
                                if let arananImg = doc.get("ilanImgUrl") as? String{
                                    if let arananIsim = doc.get("ilanIsmi") as? String{
                                        if let arananTakas1 = doc.get("ilanTakas1") as? String{
                                            if let arananTakas2 = doc.get("ilanTakas2") as? String{
                                                if let arananTakas3 = doc.get("ilanTakas3") as? String{
                                                    if let arananAdres = doc.get("ilanAdres") as? String{
                                                        if let arananMail = doc.get("ilanKullanici") as? String{
                                                            self.aramTableview.isHidden = false
                                                            if let count = snapshot?.count{
                                                                self.sonucDetayLbl.isHidden = false
                                                                self.sonucDetayLbl.text = "Arama Sonucunda \(count) ürün bulundu"
                                                            }
                                                        
                                                            let ilan = ilanModel(isim: arananIsim, gorsel: arananImg, adres: arananAdres, email: arananMail, takas1: arananTakas1, takas2: arananTakas2, takas3: arananTakas3)
                                                            self.ilanArray.append(ilan)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        self.aramTableview.reloadData()
                            
                        }
                    }
            }//add snapshotlistener
            
        }// + -
    }//func ends
    
//Row number setting func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ilanArray.count
    }

//Cell data setting func
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = aramTableview.dequeueReusableCell(withIdentifier: "aramaCellID", for: indexPath) as! AramaCell
        //cellde gösterilecek olan verileri diziden aktar
        cell.urunIsimLbl.text = ilanArray[indexPath.row].isim
        cell.aramaEposta.text = ilanArray[indexPath.row].email
        cell.aramaTakas1Lbl.text = ilanArray[indexPath.row].takas1
        cell.aramaImg.sd_setImage(with: URL(string: ilanArray[indexPath.row].gorsel), placeholderImage: UIImage(named: "ilanGorselDefault"))
        
        return cell
    }
    
//Selected Cell Data -> Variables
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //transfer verilerine diziden verileri aktar
        arananIlan = self.ilanArray[indexPath.row]
        performSegue(withIdentifier: "araToGoruntuleVC", sender: nil)
    }
    
//Variables -> SegueVC Data Variables
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "araToGoruntuleVC"{
            let destinationVC = segue.destination as! IlanGoruntuleVC
            destinationVC.secilmisIlan = self.arananIlan
        }
    }
    
    func makeAlert(baslik: String , mesaj: String){
        let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
        let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(OKButton)
        self.present(alert,animated: true,completion: nil)
    }

//messages
    
    let TxtBarError = "Görünen o ki aramak için bir kelime girmedin! Bir şeyler yazıp tekrar dener misin?"
    let urunBulunamadıMsg = "Aradığın ürünü malesef bulamadık. İsmi doğru yazdığından emin misin?"
    
}
