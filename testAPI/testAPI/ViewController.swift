//
//  ViewController.swift
//  testAPI
//
//  Created by sangheon on 2022/02/03.
//

import UIKit

struct Constants {
    static let clientID = "954973af99e44e82a2d619dbc73f585b"
    static let clientSecret = "aedbba2a96c6430c86bba00cbd5c9d69"
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    static let redirectURI = "https://www.iosacademy.io"
    static let baseAPIURL = "https://api.spotify.com/v1"
}

struct AuthResponse:Codable {
    let access_token:String
    let expires_in:Int
    let token_type:String
}


class ViewController: UIViewController {
    
    @IBAction func act(_ sender: Any) {
        print(token)
        testTrack()
    }
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshIfNeeded { success in
            print(success)
        }
    }

    public func refreshIfNeeded(completion:@escaping (Bool) -> Void) {
        
        //get Refresh token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials")
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        //header (공식문서 참조)
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("succesfully refresh")
                print("SUCCESS: \(result)")
                self?.token = result.access_token
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    func testTrack() {
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/tracks/2TpxZ7JUBn3uw46aR7qd6V")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // 띄어쓰기 ,...fuck
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,error == nil else {
                print("GET is wrong")
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(result)
            } catch {
                print("FAILE")
            }
        }
        task.resume()
    }
}

