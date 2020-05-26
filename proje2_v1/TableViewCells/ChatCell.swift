//
//  ChatCell.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 27.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var charPPImg: UIImageView!
    @IBOutlet weak var chatDispName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
