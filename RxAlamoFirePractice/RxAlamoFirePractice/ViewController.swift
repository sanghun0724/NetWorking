//
//  ViewController.swift
//  RxAlamoFirePractice
//
//  Created by sangheon on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let api:DogsAPI = DogsAPI.getInstance()
    private var dataSource:RxCollectionViewSectionedAnimatedDataSource<SectionOfDog>!
    
    let collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.minimumLineSpacing = 0
           
           layout.scrollDirection = .vertical
           layout.sectionInset = .zero
           
           let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
           cv.backgroundColor = .green
           
           return cv
       }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey")
       
        view.backgroundColor = .red
        view.addSubview(collectionView)
        collectionView.register(GridViewCell.self, forCellWithReuseIdentifier: GridViewCell.identifier)
        api.load()
        setupUI()
        
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
        
    private func setupUI() {
        title = "Dog Breeds"
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfDog>(
            configureCell: {dataSource,collectionView,IndexPath,item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridViewCell.identifier, for: IndexPath) as! GridViewCell
                cell.dog.accept(item)
                
                cell.backgroundColor = .blue
                return cell
            }
        )
    }
    
    private func setupBinding() {
        api.dogs.map { dogs in
           return [SectionOfDog(items: dogs)]
        }.bind(to: collectionView.rx.items(dataSource: self.dataSource)).disposed(by: disposeBag)
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 200, height: 200) // Return any non-zero size here
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
