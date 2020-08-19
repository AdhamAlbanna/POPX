//
//  Message.swift
//  POPX
//
//  Created by Adham Albanna on 8/16/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import UIKit

class Message {
    var text:String?
    var userName:String?
    var postDate:String?
    var imagePath:String?
    
    init(text:String?,userName:String?,postDate:String?,imagePath:String?) {
        self.text=text
        self.userName=userName
        self.postDate=postDate
        self.imagePath=imagePath
    }
}
