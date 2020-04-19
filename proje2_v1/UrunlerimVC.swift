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
    var UrunIsmiArray = [String]()
    var UrunGorselArray = [String]()//IlanOluştur.swift-Line:52->57
    var UrunTakas1Array = [String]()
    var UrunTakas2Array = [String]()
    var UrunTakas3Array = [String]()
    var UrunAdresArray = [String]()
    var UrunEpostaArray = [String]()
    var UrunIDArray = [String]()
    
    //Variables for segue 2 Ilan Kaldrı VC
    var sUIsim = ""
    var sUT1 = ""
    var sUT2 = ""
    var sUT3 = ""
    var sUImg = ""
    var sUID = ""
    
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
                    
                    self.UrunIsmiArray.removeAll(keepingCapacity: false)
                    self.UrunGorselArray.removeAll(keepingCapacity: false)
                    self.UrunAdresArray.removeAll(keepingCapacity: false)
                    self.UrunEpostaArray.removeAll(keepingCapacity: false)
                    self.UrunTakas1Array.removeAll(keepingCapacity: false)
                    self.UrunTakas2Array.removeAll(keepingCapacity: false)
                    self.UrunTakas3Array.removeAll(keepingCapacity: false)
                    
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
                                                                    
                                                                    self.UrunGorselArray.append(UrunImg)
                                                                    self.UrunIsmiArray.append(UrunIsim)
                                                                    self.UrunAdresArray.append(UrunAdres)
                                                                    self.UrunEpostaArray.append(UrunEmail)
                                                                    self.UrunTakas1Array.append(UrunTakas1)
                                                                    self.UrunTakas2Array.append(UrunTakas2)
                                                                    self.UrunTakas3Array.append(UrunTakas3)
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
    
//Row number setting func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UrunGorselArray.count
    }
    
//Cell data setting Func
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UrunlerimTableView.dequeueReusableCell(withIdentifier: "UrunlerimCellID", for: indexPath) as! UrunlerimCell
        cell.UrunlerimCellIsımLbl.text = UrunIsmiArray[indexPath.row]
        cell.UrunlerimCellTakas1Lbl.text = UrunTakas1Array[indexPath.row]
        cell.UrunlerimCellImgView.sd_setImage(with: URL(string: UrunGorselArray[indexPath.row]))
        return cell
    }
    
//Selected Cell Data -> Variables
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sUIsim = UrunIsmiArray[indexPath.row]
        self.sUT1 =  UrunTakas1Array[indexPath.row]
        self.sUT2 = UrunTakas2Array[indexPath.row]
        self.sUT3 = UrunTakas3Array[indexPath.row]
        self.sUImg = UrunGorselArray[indexPath.row]
        self.sUID = UrunIDArray[indexPath.row]
        performSegue(withIdentifier: "UrunlerimToUrunDetailVC", sender: nil)
    }
    
//Variables -> SegueVC Data Variables
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UrunlerimToUrunDetailVC"{
            let destinationVC = segue.destination as! UrunlerimDetailVC
            destinationVC.sUDIsim = self.sUIsim
            destinationVC.sUDT1 = self.sUT1
            destinationVC.sUDT2 = self.sUT2
            destinationVC.sUDT3 = self.sUT3
            destinationVC.sUDImg = self.sUImg
            destinationVC.sUDID = self.sUID
        }
    }

}
