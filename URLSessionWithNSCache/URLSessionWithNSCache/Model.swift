//
//  Model.swift
//  URLSessionWithNSCache
//
//  Created by sangheon on 2021/09/14.
//

import Foundation

struct SpaceData: Codable {
    let date:String
    let explanation:String
    let hdurl:String
    let mediaType:String
    let serviceVersion:String
    let title:String
    let url:String
    
    enum CodingKeys:String,CodingKey {
        case date,explanation,hdurl,title,url
        case mediaType = "media_type"
        case serviceVersion = "service_version"
    }
}
