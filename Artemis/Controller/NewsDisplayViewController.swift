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

protocol setFiltersDelegate {
    func setSourceName(sourceName: String)
    func setSourceId(sourceId: String)
    func setCategory(category: categories)
}

protocol refreshNewsDelegate {
    func refreshNews(callType: APICalls,category: categories,sourceName: String,page: Int)
}

// Everything except categorical news type requires both Category and Sources selection
// Categorical news already has category set so proceed to source selection

enum displayedNewsType {
    case topHeadlines
    case geopraphicNews
    case categoricalNews
    case searchNews
    case undefined
}


class NewsDisplayViewController :UITableViewController{
    
    var newsType: displayedNewsType = .undefined
    private var newsResult : News = News()
    private var delegate: webViewDelegate?
    
    private var categorySelected : categories = .undefined
    private var sourceName: String = ""
    private var sourceId: String = ""
    private var countryCode: String = ""
    private var queryString: String = ""
    private var currentPageLimit = 17
    private var currentPage = 1

    private var newsToDisplay = News(){
        didSet {
            print("News was modified")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var shouldNewsBeAppended = false
    
    func fetchNews(type: APICalls,category: categories = .undefined, query : String = "",countryCode : String = "",source: String = "",page: Int = 1) {
        Networking.sharedInstance.getNews(type: type, category: category, query: query,countryCode: countryCode,source: source,page: page){[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newsResult):
                if(self?.shouldNewsBeAppended == true){
                    self?.newsResult.articles?.append(contentsOf: newsResult.articles ?? [])
                    self?.newsToDisplay.articles?.append(contentsOf: newsResult.articles ?? [])
                    self?.shouldNewsBeAppended = false
                    return
                }
                
                self?.newsResult = newsResult
                self?.newsToDisplay = newsResult
            }
        }
    }
    
    fileprivate func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsCard.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 420
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        configureRefreshControl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Type of news called: ",newsType)
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
    
        guard indexPath.row < newsResult.articles?.count ?? 0 else {
            return NewsCard()
        }
        
        
        guard let newsArticle = newsResult.articles?[indexPath.row] else {
            print("Index not available yet")
            return NewsCard()
        }
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
    
    @objc private func dismissSelf() {
        dismiss(animated: true,completion: nil)
    }
}


private typealias setupPullToRefresh = NewsDisplayViewController
extension setupPullToRefresh {
    func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        refreshBasedOnNewsType()
        
        print("If u dont see failed above, it means it happened")
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func refreshBasedOnNewsType() {
        switch newsType {
        case .topHeadlines:
            refreshNews(callType: .sourceSearch, category: categorySelected,sourceName: sourceId)
        case .geopraphicNews:
            refreshNews(callType: .geoSearch, category: categorySelected)
        case .categoricalNews:
            refreshNews(callType: .sourceSearch, category: categorySelected,sourceName: sourceId)
        case .searchNews:
            refreshNews(callType: .querySearch, category: categorySelected,sourceName: sourceId)
        case .undefined:
            print("Pull to refresh failed")
        }
    }
    
    func resetNews() {
        newsToDisplay = News()
    }
}

private typealias setupInfiniteScroll = NewsDisplayViewController
extension setupInfiniteScroll {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("news about to be displayed: ",indexPath)
        
        if(indexPath.row > currentPageLimit){
            currentPageLimit += 20
            currentPage += 1
            shouldNewsBeAppended = true
            loadMorePages(pageNumber: currentPage)
        }
    }
    
    func loadMorePages(pageNumber: Int) {
        switch newsType {
        case .topHeadlines:
            refreshNews(callType: .sourceSearch, category: categorySelected,sourceName: sourceId,page: pageNumber)
        case .geopraphicNews:
            refreshNews(callType: .geoSearch, category: categorySelected,page: pageNumber)
        case .categoricalNews:
            refreshNews(callType: .sourceSearch, category: categorySelected,sourceName: sourceId,page: pageNumber)
        case .searchNews:
            refreshNews(callType: .querySearch, category: categorySelected,sourceName: sourceId,page: pageNumber)
        case .undefined:
            print("Unusual case occured")
        }
    }

}


extension NewsDisplayViewController: chooseCategoryDelegate{
    func selectedCategory(type: categories) {
        print("The catogery of news to be displayed is : ",type)
        fetchNews(type: .categoricalSearch,category: type)
    }
}
extension NewsDisplayViewController: querySearchDelegate{
    func querySearch(type: String,categorySelected: categories,sourceName: String) {
        print("Query search invoked with params : ",type)
        queryString = type
        fetchNews(type: .querySearch,category: categorySelected,query: type,source: sourceName)
    }
}
extension NewsDisplayViewController: geoSearchDelegate{
    func geoSearch(countryCode : String) {
        print("Geo search invoked with params : ", countryCode)
        self.countryCode = countryCode
        fetchNews(type: .geoSearch,countryCode: countryCode)
    }
}
extension NewsDisplayViewController: getNewsDelegate{
    func headlinesSearch() {
        print("Everything search invoked",self.newsToDisplay)
        fetchNews(type: .everything)
    }
}

extension NewsDisplayViewController: categorySourceDelegate{
    func getCategoricalSourceNews(type: APICalls, source: String, category: categories) {
        print("Sources news invoked with params : ",source," ",category)
        fetchNews(type: .sourceSearch,category: category, source: source)
    }
}

extension NewsDisplayViewController: setFiltersDelegate{
    func setSourceName(sourceName: String) {
        self.sourceName = sourceName
    }
    
    func setSourceId(sourceId: String) {
        self.sourceId = sourceId
        
        print("Source ID set to ", self.sourceId)
    }
    
    func setCategory(category: categories) {
        self.categorySelected = category
        print("Category set to ", self.categorySelected )
    }
}

extension NewsDisplayViewController: refreshNewsDelegate {
    func refreshNews(callType: APICalls, category: categories, sourceName: String = "",page : Int = 1) {
        print("REFRESH CALL HAPPENED TO :",callType," source: ",sourceName, "cc: ",countryCode, " query: ",queryString)
        fetchNews(type: callType,category: category, query: queryString,countryCode: countryCode,source: sourceName,page: page)
    }
}
