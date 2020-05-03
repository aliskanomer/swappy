//
//  AnaSayfaVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class AnaSayfaVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var ilanArray = [ilanModel]()
    var secilenIlan : ilanModel?
    
    //Variables for segue 2 IlanGoruntuleVC

    @IBOutlet weak var AnaSayfaTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AnaSayfaTableView.delegate = self
        AnaSayfaTableView.dataSource = self
        pullDatafromFS()
        // Do any additional setup after loading the view.
    }
    
    func pullDatafromFS(){
        ///Eski bir order hatasına çözüm methodu test aşamasında 
        /*zaman kayıt ayarları
        let settings = fsDB.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fsDB.settings = settings*/
        
        //---Data Pull Init
        let fsDB = Firestore.firestore()
        
        fsDB.collection("Ilanlar")
            .order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, snapshotError) in
            if snapshotError != nil{
                print("error") //Handling?
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{//security check
                    
                    //data reset on arrays 4 correct data show
                    
                    self.ilanArray.removeAll(keepingCapacity: false)
                    
                    //Data pull to arrays
                    
                    for doc in snapshot!.documents{
                        if let ilanImg = doc.get("ilanImgUrl") as? String{
                            if let ilanIsim = doc.get("ilanIsmi") as? String{
                                if let ilanTakas1 = doc.get("ilanTakas1") as? String{
                                    if let ilanTakas2 = doc.get("ilanTakas2") as? String{
                                        if let ilanTakas3 = doc.get("ilanTakas3") as? String{
                                            if let ilanAdres = doc.get("ilanAdres") as? String{
                                                if let ilanMail = doc.get("ilanKullanici") as? String{
                                                    let ilan = ilanModel(isim: ilanIsim, gorsel: ilanImg, adres: ilanAdres, email: ilanMail, takas1: ilanTakas1, takas2: ilanTakas2, takas3: ilanTakas3)
                                                    self.ilanArray.append(ilan)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.AnaSayfaTableView.reloadData()
                }
            }
        }
        
    }
    
//Row number setting func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return ilanGorselArray.count
        return ilanArray.count
    }
    
//Cell data setting func
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnaSayfaTableView.dequeueReusableCell(withIdentifier: "AnaSayfaCellID", for: indexPath) as! AnaSayfaCell
        cell.AnaSfCellIsımLbl.text = ilanArray[indexPath.row].isim
        
        cell.AnaSfCellTakas1Lbl.text = ilanArray[indexPath.row].takas1
        cell.AnaSfCellImgView.sd_setImage(with: URL(string: ilanArray[indexPath.row].gorsel)) //Error Handling?
        return cell
    }
    
//Selected Cell Data -> Variables
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    secilenIlan = self.ilanArray[indexPath.row]
       performSegue(withIdentifier: "anaSayfaToGoruntuleVC", sender: nil)
   }
    
//Variables -> SegueVC Data Variables
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "anaSayfaToGoruntuleVC"{
            let destinationVC = segue.destination as! IlanGoruntuleVC
            destinationVC.secilmisIlan = self.secilenIlan
        }
    }
    


}
