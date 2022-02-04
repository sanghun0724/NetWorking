//
//  GirdViewCell.swift
//  RxAlamoFirePractice
//
//  Created by sangheon on 2022/02/04.
//

import UIKit
import RxSwift
import Alamofire
import RxRelay

class GridViewCell:UICollectionViewCell {
    static let identifier = "GridViewCell"
    
    public let dog = BehaviorRelay<Dog?>(value:nil)
    
    private var dogImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("cell:\(self.dog)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
        setupBinding()
    }
    
    private func setupUI() -> Void {
        contentView.addSubview(dogImageView)
        dogImageView.frame = contentView.bounds
        
    }
    
    private func setupBinding() {
        dog.skip(1).subscribe(onNext: { dog in
            if let dog = dog  {
                self.loadImage(dog.image)
            }
        }).disposed(by: disposeBag)
    }
    
    private func loadImage(_ image:Image) {
        let url = URL(string: image.url)!
        let data = try? Data(contentsOf: url)
        dogImageView.image = UIImage(data: data!)
    }
    
}
