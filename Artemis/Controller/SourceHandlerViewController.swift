//
//  favListVC.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

enum pages{
    case category
    case sources
    case undefined
}

class SourceHandlerViewController: UITableViewController {
    
    var typeOfPage: pages = .undefined
    var newsType: displayedNewsType = .undefined
    var searchView: NewsDisplayViewController = NewsDisplayViewController()
    
    private var categorySelected : categories = .undefined
    private var sourceName: String = ""
    private var sourceId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
//        self.sources = SourcesV2(sources: [Source(name: "business"),Source(name: "health")])
//        fetchNews(type: .sources)
        setupTableView()
    }
    
    var newsFetchDelegate: categorySourceDelegate?
    private var setFiltersdelegate: setFiltersDelegate?
    private var refreshNewsDelegate: refreshNewsDelegate?
    var searchFilterDelegate : setSearchFilterDelegate?
    
    var sources = SourcesV2(sources: []){
        didSet {
            print("Sources was modified")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchSources(type: APICalls,category: categories = .undefined, query : String = "",countryCode : String = "") {
        Networking.sharedInstance.getSources(type: type, category: category, query: query,countryCode: countryCode){[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let sources):
                print("successful call : ",sources)
                self?.sources = sources
            }
        }
    }
    
    fileprivate func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SourceHandlerViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    ove
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfSections = sources.sources?.count ?? 0
//        pageControl.numberOfPages = numberOfSections
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Setting something")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SourceHandlerViewCell else {
            return SourceHandlerViewCell()
        }

        cell.layer.cornerRadius = 15
        guard let name = sources.sources?[indexPath.row] else {
            print("Index not available yet")
            return SourceHandlerViewCell()
        }
        print("The obtained results are : ",name)
        cell.set(res : name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(typeOfPage == .sources)
        {
            navigationController?.popViewController(animated: true)
            var newsView = navigationController?.topViewController as? NewsDisplayViewController
            if(newsType == .searchNews){
                newsView = searchView
            }
            
            self.newsFetchDelegate = newsView
            self.setFiltersdelegate = newsView
            self.refreshNewsDelegate = newsView
            
            sourceName = sources.sources?[indexPath.row].name ?? ""
            sourceId = sources.sources?[indexPath.row].id ?? ""
            
            setFiltersdelegate?.setSourceId(sourceId: sourceId)
            setFiltersdelegate?.setSourceName(sourceName: sourceName)
            setFiltersdelegate?.setCategory(category: categorySelected)
            
            if(newsType == .topHeadlines){
                print("CAlling SOURCE ")
                refreshNewsDelegate?.refreshNews(callType: .sourceSearch, category: categorySelected, sourceName: sourceId,page: 1)
            }
            else if(newsType == .searchNews){
                print("CALLING SEAVHCHCHCHC")
                print("Search filter deleagte ,",searchFilterDelegate)
                searchFilterDelegate?.setCategory(category: categorySelected)
                searchFilterDelegate?.setSource(source: sourceId)
                refreshNewsDelegate?.refreshNews(callType: .querySearch, category: categorySelected, sourceName: sourceId,page: 1)
            }
            else if (newsType == .categoricalNews) {
                print("CALLING CATEGORYRYRYRYR")
                refreshNewsDelegate?.refreshNews(callType: .categoricalSearch, category: categorySelected, sourceName: sourceId,page: 1)
            }
            else {
                print("UNDEFFEINEDEDNEINDENDEJUDN NEWS")
                print("UNDEFINED NEWS")
            }
            newsView?.title = "News from : " + sourceName
//            newsView?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(popViewController))
        }
        else {
            categorySelected = getCategoryAt(index: indexPath.row)
            var vcArray = self.navigationController?.viewControllers
            print("View controllers array :",vcArray)
            
            if(newsType == .geopraphicNews){
                print("calling GEOGRAPHIC")
                navigationController?.popViewController(animated: true)
                let newsView = navigationController?.topViewController as? NewsDisplayViewController
                self.setFiltersdelegate = newsView
                self.refreshNewsDelegate = newsView
                
                setFiltersdelegate?.setCategory(category: categorySelected)
                refreshNewsDelegate?.refreshNews(callType: .geoSearch, category: categorySelected,sourceName: "",page: 1)
                return
            }
            
            fetchSources(type: .sources,category: categorySelected)
            typeOfPage = .sources
        }
    }
    
    @objc func popViewController(){
        print("Popping the view controller")
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCategoryAt(index: Int) -> categories{
        switch categoryList[index] {
        case "Buisness" : return .business
        case "Sports" : return .sports
        case "Technology" : return .technology
        case "Entertainment" : return .entertainment
        case "Health": return .health
        case "Science": return .science
        case "General": return .general
        default:
            return .undefined
        }
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true,completion: nil)
        resetCatergoriesView()
        typeOfPage = .category
    }
    
    func resetCatergoriesView(){
        sources = SourcesV2(sources: [])
        for category in categoryList {
            sources.sources?.append(Source(name: category))
        }
    }
}
