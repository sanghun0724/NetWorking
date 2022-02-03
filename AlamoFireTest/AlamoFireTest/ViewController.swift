//
//  ViewController.swift
//  AlamoFireTest
//
//  Created by sangheon on 2022/01/28.
//

import UIKit
import Alamofire




struct User :Decodable{
    let name:String
    let email:String
}

class ViewController: UIViewController {
    
    struct Constants {
        static let usersUrl = URL(string: "https://jsonplaceholder.typicode.com/users")!
        static let toddlistUrl = URL(string: "https://jsonplaceholder.typicode.com/todos")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getTest()
        postTest()
    }
    
    
    //MARK: -GET
    private func getTest() {
        AF.request(Constants.usersUrl, method: .get, parameters: .none, encoding: URLEncoding.default, headers: ["Content-Type":"applicatoin/json","Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of:[User].self) { response in
                print(response)
            }
       }
    
    //MARK: -POST
    let username = "gracia"
    let password = "1234"
    private func postTest() {
        let url = "http://www.ptsv2.com/t/kf582-1643354338/post"
        //let header:HTTPHeaders = ["Content-Type":"applicatoin/json"]
        
        var request = URLRequest(url:URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //post로 보낼정보
        let params:[String:Any] = [
            "name":username,
            "password":password
        ]
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http body error")
        }
        
        AF.request(request).responseString { response in
            switch response.result {
            case .success:
                print("post Success")
            case .failure(let error):
                print(error)
            }
        }
      }
    
    
    
}


