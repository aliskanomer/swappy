//
//  AramaCell.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 21.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit

class AramaCell: UITableViewCell {

    @IBOutlet weak var urunIsimLbl: UILabel!
    @IBOutlet weak var aramaImg: UIImageView!
    @IBOutlet weak var aramaEposta: UILabel!
    @IBOutlet weak var aramaTakas1Lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
