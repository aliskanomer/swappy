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
    //Arrays 4 TableView
    var ilanIsmiArray = [String]()
    var ilanGorselArray = [String]()//IlanOluştur.swift-Line:52->57
    var ilanTakas1Array = [String]()
    var ilanTakas2Array = [String]()
    var ilanTakas3Array = [String]()
    var ilanAdresArray = [String]()
    var ilanEpostaArray = [String]()
    
    //Variables for segue 2 IlanGoruntuleVC
    var sAdres = ""
    var sIsim = ""
    var sEposta = ""
    var sT1 = ""
    var sT2 = ""
    var sT3 = ""
    var sImg = ""
    
    
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
                    
                    self.ilanGorselArray.removeAll(keepingCapacity: false)
                    self.ilanIsmiArray.removeAll(keepingCapacity: false)
                    self.ilanAdresArray.removeAll(keepingCapacity: false)
                    self.ilanEpostaArray.removeAll(keepingCapacity: false)
                    self.ilanTakas1Array.removeAll(keepingCapacity: false)
                    self.ilanTakas2Array.removeAll(keepingCapacity: false)
                    self.ilanTakas3Array.removeAll(keepingCapacity: false)
                    
                    //Data pull to arrays
                    
                    for doc in snapshot!.documents{
                        if let ilanImg = doc.get("ilanImgUrl") as? String{
                            if let ilanIsim = doc.get("ilanIsmi") as? String{
                                if let ilanTakas1 = doc.get("ilanTakas1") as? String{
                                    if let ilanTakas2 = doc.get("ilanTakas2") as? String{
                                        if let ilanTakas3 = doc.get("ilanTakas3") as? String{
                                            if let ilanAdres = doc.get("ilanAdres") as? String{
                                                if let ilanMail = doc.get("ilanKullanici") as? String{
                                                    self.ilanGorselArray.append(ilanImg)
                                                    self.ilanIsmiArray.append(ilanIsim)
                                                    self.ilanTakas1Array.append(ilanTakas1)
                                                    self.ilanTakas2Array.append(ilanTakas2)
                                                    self.ilanTakas3Array.append(ilanTakas3)
                                                    self.ilanAdresArray.append(ilanAdres)
                                                    self.ilanEpostaArray.append(ilanMail)
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
        return ilanGorselArray.count
    }
    
//Cell data setting func
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnaSayfaTableView.dequeueReusableCell(withIdentifier: "AnaSayfaCellID", for: indexPath) as! AnaSayfaCell
        cell.AnaSfCellIsımLbl.text = ilanIsmiArray[indexPath.row]
        cell.AnaSfCellTakas1Lbl.text = ilanTakas1Array[indexPath.row]
        cell.AnaSfCellImgView.sd_setImage(with: URL(string: ilanGorselArray[indexPath.row])) //completion block yok. Error Handling?
        return cell
    }
    
//Selected Cell Data -> Variables
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sIsim = ilanIsmiArray[indexPath.row]
        self.sAdres = ilanAdresArray[indexPath.row]
        self.sEposta = ilanEpostaArray[indexPath.row]
        self.sT1 = ilanTakas1Array[indexPath.row]
        self.sT2 = ilanTakas2Array[indexPath.row]
        self.sT3 = ilanTakas3Array[indexPath.row]
        self.sImg = ilanGorselArray[indexPath.row]
       performSegue(withIdentifier: "anaSayfaToGoruntuleVC", sender: nil)
   }
    
//Variables -> SegueVC Data Variables
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "anaSayfaToGoruntuleVC"{
            let destinationVC = segue.destination as! IlanGoruntuleVC
            destinationVC.sIsim = self.sIsim
            destinationVC.sAdres = self.sAdres
            destinationVC.sEposta = self.sEposta
            destinationVC.sT1 = self.sT1
            destinationVC.sT2 = self.sT2
            destinationVC.sT3 = self.sT3
            destinationVC.sImg = self.sImg

        }
    }
    


}
