//
//  CurrentUsersChatVC.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 27.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit
import Firebase

class CurrentUsersChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 5
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.chatDispName.text = Auth.auth().currentUser?.uid
        return cell
       }

}
