//
//  ViewController.swift
//  Network_Practice1
//
//  Created by sangheon on 2021/05/20.
//

import UIKit

class ViewController: UIViewController{
    let urlString = "https://api.androidhive.info/contacts/"
    @IBOutlet weak var textView:UITextView!
    
    private let networkingClient = NetWorkManager()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
           
    }

    @IBAction func executeRequest(_ sender:Any) {
        guard let urlToExecute = URL(string: urlString) else {
            return
        }
        networkingClient.getData(url: urlToExecute) { (json,error) in
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                self.textView.text = json.description
            }
        }
    }

}

