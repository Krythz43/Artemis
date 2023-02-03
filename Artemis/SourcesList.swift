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

class SourcesList: UITableViewController {
    
    var typeOfPage: pages = .undefined
    private var categorySelected : categories = .undefined

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
//        self.sources = SourcesV2(sources: [Source(name: "business"),Source(name: "health")])
//        fetchNews(type: .sources)
        setupTableView()
    }
    
    var newsFetchDelegate: categorySourceDelegate?
    
    var sources = SourcesV2(sources: []){
        didSet {
            print("Sources was modified")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchNews(type: APICalls,category: categories = .undefined, query : String = "",countryCode : String = "") {
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
        tableView.register(SourceViewCell.self, forCellReuseIdentifier: "Cell")
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SourceViewCell else {
            return SourceViewCell()
        }

        cell.layer.cornerRadius = 15
        guard let name = sources.sources?[indexPath.row] else {
            print("Index not available yet")
            return SourceViewCell()
        }
        print("The obtained results are : ",name)
        cell.set(res : name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(typeOfPage == .sources)
        {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let newsView = TableViewController()
            self.newsFetchDelegate = newsView
            
            let sourceName = sources.sources?[indexPath.row].name ?? ""
            let sourceId = sources.sources?[indexPath.row].id ?? ""
            newsFetchDelegate?.getCategoricalSourceNews(type: .sourceSearch, source: sourceId, category: categorySelected)
            
            newsView.title = "News from : " + sourceName
            newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(dismissSelf))
            
            let navVC = UINavigationController(rootViewController: newsView)
            
            navVC.modalPresentationStyle = .fullScreen
            present(navVC,animated: true,completion: nil)
        }
        else {
            tableView.deselectRow(at: indexPath, animated: true)
            categorySelected = getCategoryat(index: indexPath.row)
            fetchNews(type: .sources,category: categorySelected)
            typeOfPage = .sources
        }
    }
    
    func getCategoryat(index: Int) -> categories{
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
