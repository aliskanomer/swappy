//
//  chat.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 5.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import Foundation
import UIKit

struct Chat {
    
    var users: [String]
    
    var dictionary: [String: Any] {
        return [
            "users": users
        ]
    }
}

extension Chat {
    
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
    
}
