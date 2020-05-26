//
//  UrunlerimVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class UrunlerimVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //Arrays 4 TableView
    var UrunIDArray = [String]()
    var sUID = ""
    var ilanArray = [ilanModel]()
    var secilenUrun : ilanModel?
    
    @IBOutlet weak var UrunlerimTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UrunlerimTableView.dataSource = self
        UrunlerimTableView.delegate = self
        UrunlerimPullDataFromFS()
    }
    
    func UrunlerimPullDataFromFS(){
        let uFsDb = Firestore.firestore()
        uFsDb.collection("Ilanlar")
            .order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, UrunlerSnapshotError) in
                if UrunlerSnapshotError != nil{
                    print("Error") //Handling?
                }else{
                    
                    //data reset on arrays
                    
                    self.ilanArray.removeAll(keepingCapacity: false)
                    
                    //User check > for loop > users data pull request
                    if Auth.auth().currentUser != nil {
                        let currentUserID = Auth.auth().currentUser?.email
                        
                        for doc in snapshot!.documents{
                            
                            //Kullaniciya ait postları tüm postların arasından seçen if-else merdiveni
                            
                            if let kullanici = doc.get("ilanKullanici") as? String{
                                if kullanici == currentUserID{
                                    
                                    //Verilerin bağımlı pull işlemlerinin kontrolünü sağlayan if-else merdiveni
                                    
                                    if let UrunImg = doc.get("ilanImgUrl") as? String{
                                        if let UrunIsim = doc.get("ilanIsmi") as? String{
                                            if let UrunAdres = doc.get("ilanAdres") as? String{
                                                if let UrunEmail = doc.get("ilanKullanici") as? String{
                                                    if let UrunTakas1 = doc.get("ilanTakas1") as? String{
                                                        if let UrunTakas2 = doc.get("ilanTakas2") as? String{
                                                            if let UrunTakas3 = doc.get("ilanTakas3") as? String{
                                                                    //Push data 2 Arrays
                                                                    
                                                                    let ilan = ilanModel(isim: UrunIsim, gorsel: UrunImg, adres: UrunAdres, email: UrunEmail, takas1: UrunTakas1, takas2: UrunTakas2, takas3: UrunTakas3)
                                                                self.ilanArray.append(ilan)
                                                                    self.UrunIDArray.append(doc.documentID)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        self.UrunlerimTableView.reloadData()
                }
            }
        }
    }

    //TableView Protocols & Segue Function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ilanArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UrunlerimTableView.dequeueReusableCell(withIdentifier: "UrunlerimCellID", for: indexPath) as! UrunlerimCell
        cell.UrunlerimCellIsımLbl.text = ilanArray[indexPath.row].isim
        cell.UrunlerimCellTakas1Lbl.text = ilanArray[indexPath.row].takas1
        cell.UrunlerimCellImgView.sd_setImage(with: URL(string: ilanArray[indexPath.row].gorsel), placeholderImage: UIImage(named: "ilanGorselDefault"))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sUID = UrunIDArray[indexPath.row]
        secilenUrun = self.ilanArray[indexPath.row]
        performSegue(withIdentifier: "UrunlerimToUrunDetailVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UrunlerimToUrunDetailVC"{
            let destinationVC = segue.destination as! UrunlerimDetailVC
            destinationVC.secilmisIlan = self.secilenUrun
            destinationVC.sUDID = self.sUID
        }
    }
}
