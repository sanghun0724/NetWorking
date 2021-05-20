//
//  Model.swift
//  Network_Practice1
//
//  Created by sangheon on 2021/05/21.
//

import Foundation

struct APIRespone: Codable {
    let contacts:[Contact]
}

struct Contact:Codable {
    let name:String
    let email:String
    let gender:String
}
