//
//  ImageLoader.swift
//  URLSessionWithNSCache
//
//  Created by sangheon on 2021/09/14.
//.as

import UIKit

class ImageLoader {
    private static let imageChache = NSCache<NSString,UIImage>()
    
    static func loadImage(url:String,completion:@escaping (UIImage?)->Void) {
        //url 없다면 nil처리
        if url.isEmpty {
            completion(nil)
            return
        }
        
        let realURL = URL(string: url)!
        
        //cache에 존재한다면 바로 반환
        if let image = imageChache.object(forKey: realURL.lastPathComponent as NSString) {
            print("cache에 존재")
            DispatchQueue.main.async {
                completion(image)
            }
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            print("cache에 없음")
            
            if let data = try? Data(contentsOf: realURL) {
                let image = UIImage(data:data)!
                
                self.imageChache.setObject(image, forKey: realURL.lastPathComponent as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        
    }
    
}
