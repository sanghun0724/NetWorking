//
//  ViewController.swift
//  URLSessionWithNSCache
//
//  Created by sangheon on 2021/09/14.
//

import UIKit

class ViewController: UIViewController {
    
    var apiHandler:APIService = APIService()
    
    var spaceData:SpaceData? {
        didSet {
            print("data fetch completed")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("hi")
        config()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter+=1
            self.timeLabel.text = "\(self.counter)"
        }
    }
    //비동기 - 시간재기
    var counter = 0
    //load Button
    lazy var loadButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("사진불러오기", for: .normal)
        bt.setTitleColor(.white, for: UIControl.State.normal)
        bt.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        bt.titleLabel?.textAlignment = .center
        
        let size:CGFloat = 5
       // bt.titleEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.layer.masksToBounds = false
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .black
        bt.addTarget(self, action: #selector(loadSpaceData), for: .touchUpInside)
        return bt
    }()
    
    //clear button
    lazy var clearButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("clear", for: .normal)
        bt.setTitleColor(.white, for: UIControl.State.normal)
        bt.titleLabel?.font  = UIFont(name: "Helvetica-Bold", size: 17)
        bt.titleLabel?.textAlignment = .center
        
        let size:CGFloat = 5
        bt.titleEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        bt.layer.masksToBounds = false
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .systemIndigo
        bt.addTarget(self, action: #selector(clear), for: .touchUpInside)
        return bt
    }()
    
    //clear Action
    @objc func clear() {
        self.counter = 0
        self.spaceImage.image = nil
        self.explanationLabel.text = nil
        self.titleLabel.text = nil
        self.dateLabel.text = nil
        
    }
    
    lazy var timeLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 15)
        return lb
    }()
    
    //Main Image
    lazy var spaceImage:UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = false
        image.layer.cornerRadius = image.frame.width / 2 //round
        return image
    }()
    
    //title
    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica-Bold", size: 24)
        return lb
    }()
    
    //Date
    lazy var dateLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Helvetica", size: 14)
        return lb
    }()
    
    //explaination
    lazy var explanationLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.font = UIFont(name:"Helveica",size: 15)
        return lb
    }()
    
    //indicatorView
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = .black
        return indicator
    }()
    
    @objc func loadSpaceData() {
        //불러옴과 동시에 indicator 시작
        activityIndicatorView.startAnimating()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.apiHandler.getData { (data) in
                self.spaceData = data
                
                guard let data = self.spaceData else {
                    return
                }
                
                //image Load
                ImageLoader.loadImage(url: data.url) { [weak self] image in
                    //main thread
                    self?.spaceImage.image = image
                    self?.activityIndicatorView.stopAnimating()
                    self?.titleLabel.text = data.title
                    self?.explanationLabel.text = data.explanation
                    self?.dateLabel.text = data.date
                    print(data.explanation)
                }
            }
        }
    }
    
    func config() {
        view.backgroundColor = .white
        
        [clearButton,loadButton,spaceImage,titleLabel,explanationLabel,dateLabel,activityIndicatorView,timeLabel].forEach { (item) in
            self.view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            spaceImage.topAnchor.constraint(equalTo: self.view.topAnchor),
            spaceImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            spaceImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            spaceImage.heightAnchor.constraint(equalToConstant: 400.0),
            
            titleLabel.topAnchor.constraint(equalTo: spaceImage.bottomAnchor,constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: spaceImage.leadingAnchor,constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: spaceImage.trailingAnchor,constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            explanationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant: 20),
            explanationLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            explanationLabel.heightAnchor.constraint(equalToConstant: 200.0),
            
            loadButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -50),
            loadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadButton.widthAnchor.constraint(equalToConstant: 200.0),
            
            clearButton.trailingAnchor.constraint(equalTo: loadButton.leadingAnchor, constant: -10),
            clearButton.centerYAnchor.constraint(equalTo: loadButton.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 60),
            
            timeLabel.leadingAnchor.constraint(equalTo: loadButton.trailingAnchor, constant: 20),
            timeLabel.centerYAnchor.constraint(equalTo: loadButton.centerYAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        
        
        ])
    }
    

}

