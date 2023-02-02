//
//  TableViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 17/01/23.
//

import UIKit

protocol webViewDelegate {
    func loadWebPage(targetURL: String)
    func loadView()
}


class TableViewController : UITableViewController, UITableViewDataSourcePrefetching, chooseCategoryDelegate, querySearchDelegate, geoSearchDelegate, getNewsDelegate {
    
    
    
    func geoSearch(countryCode : String) {
        print("Geo search invoked with params : ", countryCode)
        fetchNews(type: .geoSearch,countryCode: countryCode)
    }
    
    func headlinesSearch() {
        print("Everything search invoked",self.newsToDisplay)
        fetchNews(type: .everything)
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
    
    private var newsResult : News = News()
    private var delegate: webViewDelegate?
    
    private var newsToDisplay = News(){
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
            
//            print("API CALL WAS SUCESS", self?.newsToDisplay)
        }
        
//        print(newsResult)
    }
    
    fileprivate func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsCard.self, forCellReuseIdentifier: "Cell") // register tableView cells as cell
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        print("Table view delegate ",tableView.prefetchDataSource)
        tableView.rowHeight = 420
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? NewsCard else {
            return NewsCard()
        }
            
        cell.layer.cornerRadius = 15
        guard indexPath.row < newsResult.articles?.count ?? 0 else {
            return NewsCard()
        }
        
        guard let newsArticle = newsResult.articles?[indexPath.row] else {
            print("Index not available yet")
            return NewsCard()
        }
//        print("The obtained results are : ",newsArticle)
        cell.set(res : newsArticle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let webView = BrowserViewController()
        delegate = webView
        delegate?.loadView()
        
        webView.title = newsToDisplay.articles?[indexPath.row].source?.name ?? ""
        
        webView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(dismissSelf))

        print("Url to display : ", newsToDisplay.articles?[indexPath.row].url ?? "")
        delegate?.loadWebPage(targetURL: newsToDisplay.articles?[indexPath.row].url ?? "")
        
        let navVC = UINavigationController(rootViewController: webView)
        
        navVC.modalPresentationStyle = .fullScreen
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        present(navVC,animated: true,completion: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetch shall happen at: ",indexPaths)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("prefetch shall be cancelled at: ",indexPaths)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true,completion: nil)
    }
}
