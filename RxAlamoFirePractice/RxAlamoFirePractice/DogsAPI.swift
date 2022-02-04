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
import SwiftUI


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
}
