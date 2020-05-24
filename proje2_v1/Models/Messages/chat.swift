//
//  chat.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 5.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import Foundation



struct Chat {
    var kullaniciArray : [String]
    var chatModeldictionary : [String : Any]{
        return ["chattekiKullanicilar" : kullaniciArray]
    }
}
extension Chat{
    init?(dictionary : [String:Any]){
        guard let chattekiKullanicilar = dictionary["chattekiKullanicilar"] as? [String] else {
            return nil
        }
        self.init(kullaniciArray : chattekiKullanicilar)
    }
}

