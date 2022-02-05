//
//  DogsAPI.swift
//  RxAlamoFirePractice
//
//  Created by sangheon on 2022/02/04.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources


struct Weight :Equatable, Codable {
    var imperial:String
    var metric:String
}

struct Height : Equatable, Codable {
    var imperial:String
    var metric:String
}

struct Image :Equatable,Codable {
    var id:String
    var width:Int
    var height:Int
    var url:String
}

struct Dog :Equatable,Codable {
    var weight:Weight
    var height:Height
    var id:Int
    var name:String
    var breed_group:String?
    var life_span:String
    var temperament:String?
    var reference_image_id:String
    var image:Image
}

extension Dog:IdentifiableType {
    typealias Identity = Int
    
    var identity:Identity {
        return id
    }
}

struct SectionOfDog {
    var header:String = ""
    var items:[Item]
}

extension SectionOfDog:AnimatableSectionModelType {
    typealias Item = Dog
    
    init(original: SectionOfDog, items: [Dog]) {
        self = original
        self.items = items
    }
    
    var identity:String {
        return header
    }
}


class DogsAPI {
    private static let instance:DogsAPI = DogsAPI()
    
    public let dogs = BehaviorRelay<[Dog]>(value: [])
    public let myError = BehaviorRelay<Error?>(value: nil)
    
    private let apiUrl = "https://api.thedogapi.com/v1/breeds"
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    public static func getInstance() -> DogsAPI {
        return instance
    }
    
    public func load() -> Void {
        let url = URL(string: apiUrl)!
        
        var request = URLRequest(url:url)
        request.method = .get
        request.headers = [
            "x-api-key":Const.APIKey,
            "Accept":"application/json"
        ]
        
        RxAlamofire.requestJSON(request).subscribe(onNext: { (respone,any) in
                do {
                    let data = try JSONSerialization.data(withJSONObject: any)
                    let dog = try JSONDecoder().decode([Dog].self, from: data)
                    self.dogs.accept(dog)
//                    print(self.dogs.value)
                } catch let error {
                    self.myError.accept(error)
                }
            
        }).disposed(by: disposeBag)
    }
    
    
    
    let username = "gracia"
    let password = "1234"
    public func postTest() {
        let url = "https://ptsv2.com/t/stwtx-1644057177/post"
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
        
        RxAlamofire.request(request).response()
            .subscribe(onNext: { respone in
                if respone.statusCode < 500 {
                    print("good")
                }
            
            
        }).disposed(by: disposeBag)
        
      }
}
