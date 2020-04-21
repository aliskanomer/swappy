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
    
    //tableView Arrays
    
    var AramaIsimArray = [String]()
    var AramaEpostaArray = [String]()
    var AramaImgArray = [String]()
    var AramaAdresArray = [String]()
    var AramaTakas1Array = [String]()
    var AramaTakas2Array = [String]()
    var AramaTakas3Array = [String]()
    
    //transfer variables
    
    var sAIsim = ""
    var sAT1 = ""
    var sAT2 = ""
    var sAT3 = ""
    var sAImg = ""
    var sAadres = ""
    var sAEposta = ""
    
    //variables
    override func viewDidLoad() {
        super.viewDidLoad()
        aramTableview.delegate = self
        aramTableview.dataSource = self
        aramTableview.isHidden = true
    }
    
    @IBAction func AraBtnClicked(_ sender: Any) {
        if AramaTxt.text == "" {
            makeAlert(baslik: "Ups!", mesaj: TxtBarError)
        }else{
            dataPull4Search()
            aramTableview.isHidden = false
            aramTableview.reloadData()
        }
    }
    func dataPull4Search(){
        if AramaTxt.text != ""{
            let FireStoreRef = Firestore.firestore()
            FireStoreRef.collection("Ilanlar")
                .whereField("ilanIsim", isEqualTo: AramaTxt.text!)
                .order(by: "date", descending: true)
                .addSnapshotListener { (snapshot, snapshotError) in
                    if snapshotError != nil{
                        print("Error")
                    }else{
                        if snapshot?.isEmpty != true && snapshot != nil{
                            //aranan isimde belgeler var ve snapshotQuery döndü demektir
                            
                        }else{
                            //aranabelge yok ve sonuç dönmedi demektir
                            //snapshotın nill olma sebebi sadece verinin olmaması durumuysa diye bunu düşündüm. Snapshotın nill olma sebeğlerini araştır
                        }
                    }
            }

        }else{
            makeAlert(baslik: "Ups!", mesaj: TxtBarError)
        }
        
        
        
        /*self.AramaImgArray.append("https://homepages.cae.wisc.edu/~ece533/images/airplane.png")
        self.AramaIsimArray.append("ilanIsim")
        self.AramaTakas1Array.append("ilanTakas1")
        self.AramaTakas2Array.append("ilanTakas2")
        self.AramaTakas3Array.append("ilanTakas3")
        self.AramaAdresArray.append("ilanAdres")
        self.AramaEpostaArray.append("ilanMail")*/
    }
    
//Row number setting func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AramaImgArray.count
    }
    
    
//Cell data setting func
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = aramTableview.dequeueReusableCell(withIdentifier: "aramaCellID", for: indexPath) as! AramaCell
        //cellde gösterilecek olan verileri diziden aktar
        cell.urunIsimLbl.text = AramaIsimArray[indexPath.row]
        cell.aramaEposta.text = AramaEpostaArray[indexPath.row]
        cell.aramaTakas1Lbl.text = AramaTakas1Array[indexPath.row]
        cell.aramaImg.sd_setImage(with: URL(string: AramaImgArray[indexPath.row]))
        
        return cell
    }
    
//Selected Cell Data -> Variables
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //transfer verilerine diziden verileri aktar
        self.sAIsim = AramaIsimArray[indexPath.row]
        self.sAT1 = AramaTakas1Array[indexPath.row]
        self.sAT2 = AramaTakas2Array[indexPath.row]
        self.sAT3 = AramaTakas3Array[indexPath.row]
        self.sAImg = AramaImgArray[indexPath.row]
        self.sAadres = AramaAdresArray[indexPath.row]
        self.sAEposta = AramaEpostaArray[indexPath.row]
        performSegue(withIdentifier: "araToGoruntuleVC", sender: nil)
    }
    
//Variables -> SegueVC Data Variables
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "araToGoruntuleVC"{
            let destinationVC = segue.destination as! IlanGoruntuleVC
            destinationVC.sIsim = self.sAIsim
            destinationVC.sAdres = self.sAadres
            destinationVC.sEposta = self.sAEposta
            destinationVC.sT1 = self.sAT1
            destinationVC.sT2 = self.sAT2
            destinationVC.sT3 = self.sAT3
            destinationVC.sImg = self.sAImg
        }
    }
    
//self functions
    func diziTemizle(){
        self.AramaImgArray.removeAll(keepingCapacity: false)
        self.AramaIsimArray.removeAll(keepingCapacity: false)
        self.AramaAdresArray.removeAll(keepingCapacity: false)
        self.AramaEpostaArray.removeAll(keepingCapacity: false)
        self.AramaTakas1Array.removeAll(keepingCapacity: false)
        self.AramaTakas2Array.removeAll(keepingCapacity: false)
        self.AramaTakas3Array.removeAll(keepingCapacity: false)
    }
    
    func makeAlert(baslik: String , mesaj: String){
        let alert = UIAlertController(title: baslik, message: mesaj, preferredStyle: UIAlertController.Style.alert)
        let OKButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(OKButton)
        self.present(alert,animated: true,completion: nil)
    }
    
    //messages
    
    let TxtBarError = "Görünen o ki aramak için bir kelime girmedin! Bir şeyler yazıp tekrar dener misin?"
    
}
