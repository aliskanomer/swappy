//
//  Message.swift
//  proje2_v1
//
//  Created by Ömer Faruk Alışkan on 5.05.20.
//  Copyright © 2020 Ömer Faruk Alışkan. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MessageKit

struct Message {
    var id : String
    var content : String
    var created : Timestamp
    var senderID : String
    var senderName : String
    var dictionary : [String : Any]{
        return[
            "id" : id,
            "content" : content,
            "created" : created,
            "senderID" : senderID,
            "senderName" : senderName
            ]
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? Timestamp,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String
            else {return nil}
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
    }
}

//message kit için gerekli extensionlar

extension Message: MessageType {
    
    var sender: SenderType {
        return Sender(id: senderID, displayName: senderName)
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return created.dateValue()
    }
    
    var kind: MessageKind {
        return .text(content)
    }
}
