//
//  UrunlerimCell.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 17.04.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit

class UrunlerimCell: UITableViewCell {

    @IBOutlet weak var UrunlerimCellImgView: UIImageView!
    @IBOutlet weak var UrunlerimCellIsımLbl: UILabel!
    @IBOutlet weak var UrunlerimCellTakas1Lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
