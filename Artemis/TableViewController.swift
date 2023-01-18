//
//  TableViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 17/01/23.
//

import UIKit

class TableViewController : UITableViewController {
    
    var newsResult : News = News()
    
    var newsToDisplay = News(){
        didSet {
            print("News was modified")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchNews() {
        Networking.sharedInstance.getNews{[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newsResult):
                self?.newsResult = newsResult
                self?.newsToDisplay = newsResult
            }
        }
        
        print(newsResult)
    }
    
    fileprivate func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsCard.self, forCellReuseIdentifier: "Cell") // register tableView cells as cell
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 420
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        fetchNews()
        setupTableView()
        
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Number of sections to be processed : ",newsResult.articles?.count ?? 0)
        return newsResult.articles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NewsCard
        cell.layer.cornerRadius = 15
        let newsArticle = newsResult.articles?[indexPath.row]
        cell.set(res : newsArticle)
        return cell
    }
}
