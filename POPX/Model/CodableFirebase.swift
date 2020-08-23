//
//  CodableFirebase.swift
//  POPX
//
//  Created by Adham Albanna on 8/19/20.
//  Copyright © 2020 Adham Albanna. All rights reserved.
//

import Foundation


struct CodableFirebase: Codable {
    
    var userName: String?
    var age: Int?
    var gender: String?


    
    enum CodingKeys: String, CodingKey {
        case userName
        case age
        case gender

    }
}
