//
//  uyeler.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 3.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import Foundation

struct UyeStruct {
    var displayName : String
    var email : String
    var password : String
    var profileImg : String
    var uyeDic : [String:Any]{
        return [
            "ePosta" : email,
            "password" : password,
            "profileImg" : profileImg,
            "displayName" : displayName
        ]
    }
    
}



