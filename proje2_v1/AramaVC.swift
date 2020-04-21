//
//  AramaVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit

class AramaVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var AramaLbl: UILabel!
    @IBOutlet weak var AramaTxt: UITextField!
    @IBOutlet weak var aramTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aramTableview.delegate = self
        aramTableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AraBtnClicked(_ sender: Any) {
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
}
