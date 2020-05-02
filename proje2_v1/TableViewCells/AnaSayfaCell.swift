//
//  AnaSayfaCell.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit

class AnaSayfaCell: UITableViewCell {

    @IBOutlet weak var AnaSfCellImgView: UIImageView!
    @IBOutlet weak var AnaSfCellIsımLbl: UILabel!
    @IBOutlet weak var AnaSfCellTakas1Lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
