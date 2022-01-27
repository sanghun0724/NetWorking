//
//  APIService.swift
//  URLSessionWithNSCache
//
//  Created by sangheon on 2021/09/14.
//

import Foundation

class APIService {
    func getData(comletion: @escaping (SpaceData)->()) {
    let key = "Z62c8V0sniJuS7UAN9E4iJShgDbWZEZZWdcDNQLK"
    let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(key)")!
    let requestURL = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: requestURL) { (data, respone, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            if let data = data, let respone = respone as? HTTPURLResponse, respone.statusCode == 200 {
                do {
                    let parsedData = try JSONDecoder().decode(SpaceData.self, from: data)
                    comletion(parsedData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
}
}
