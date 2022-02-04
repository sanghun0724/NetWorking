//
//  FeedViewController.swift
//  RxAlamoFirePractice
//
//  Created by sangheon on 2022/02/04.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let tableView :UITableView = {
        let table = UITableView()
        table.register(FeedViewCell.self, forCellReuseIdentifier:FeedViewCell.identifier )
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}
