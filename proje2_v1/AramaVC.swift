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
    //transfer datas
    var sAIsim = ""
    var sAT1 = ""
    var sAT2 = ""
    var sAT3 = ""
    var sAImg = ""
    var sAadres = ""
    var sAEposta = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        aramTableview.delegate = self
        aramTableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AraBtnClicked(_ sender: Any) {
        dataPull4Search()
    }
    func dataPull4Search(){
        
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
        self.sAT1 = AramaIsimArray[indexPath.row]
        self.sAT2 = AramaIsimArray[indexPath.row]
        self.sAT3 = AramaIsimArray[indexPath.row]
        self.sAImg = AramaIsimArray[indexPath.row]
        self.sAadres = AramaIsimArray[indexPath.row]
        self.sAEposta = AramaIsimArray[indexPath.row]
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
    
}
