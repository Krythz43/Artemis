//
//  TableViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 17/01/23.
//

import UIKit

class TableViewController : UITableViewController, chooseCategoryDelegate, querySearchDelegate, geoSearchDelegate {
    
    func geoSearch(countryCode : String) {
        print("Geo search invoked with params : ", countryCode)
        fetchNews(type: .geoSearch,countryCode: countryCode)
    }
    
    func querySearch(type: String) {
        print("Query search invoked with params : ",type)
        fetchNews(type: .querySearch,query: type)
    }
    
    func resetNews() {
        newsToDisplay = News()
    }
    
    func selectedCategory(type: categories) {
        print("The catogery of news to be displayed is : ",type)
        fetchNews(type: .categoricalSearch,category: type)
    }
    
    var newsResult : News = News()
    
    var newsToDisplay = News(){
        didSet {
            print("News was modified")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchNews(type: APICalls,category: categories = .undefined, query : String = "",countryCode : String = "") {
        Networking.sharedInstance.getNews(type: type, category: category, query: query,countryCode: countryCode){[weak self] result in
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
        
//        fetchNews(type: .categoricalSearch,category: .sports)
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
