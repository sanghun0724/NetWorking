//
//  NetWorkManager.swift
//  Network_Practice1
//
//  Created by sangheon on 2021/05/21.
//

import Foundation
import Alamofire

class NetWorkManager {
    
    func getData(url:URL,completion:@escaping ([[String:Any]]?,Error?) -> Void){
        AF.request(url).validate().responseJSON { response in
            if let error = response.error {
                completion(nil,error)
            } else if let jsonArray = response.value as? [[String:Any]] {
                completion(jsonArray,nil)
            } else if let jsonDict = response.value as? [String:Any] {
                completion([jsonDict],nil)
            }
        }
        
    }
    
    
}
