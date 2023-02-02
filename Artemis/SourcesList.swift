//
//  favListVC.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

class SourcesList: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        fetchNews(type: .sources)
        setupTableView()
    }
    
    var delegate: singularSourceDelegate?
    
    private var sources = SourcesV2(sources: []){
        didSet {
            print("News was modified")
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
        
        print("Number of sections to be processed : ",sources.sources?.count ?? 0)
        return sources.sources?.count ?? 0
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newsView = TableViewController()
        self.delegate = newsView
        
        let sourceName = sources.sources?[indexPath.row].name ?? ""
        delegate?.getSourceNews(type: .singularSourceSearch, source: sourceName)
        
        newsView.title = "News from : " + sourceName
        newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(dismissSelf))
        
        let navVC = UINavigationController(rootViewController: newsView)
        
        navVC.modalPresentationStyle = .fullScreen
        present(navVC,animated: true,completion: nil)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true,completion: nil)
    }
    
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let webView = BrowserViewController()
//        delegate = webView
//        delegate?.loadView()
//
//        webView.title = newsToDisplay.articles?[indexPath.row].source?.name ?? ""
//
//        webView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(dismissSelf))
//
//        print("Url to display : ", newsToDisplay.articles?[indexPath.row].url ?? "")
//        delegate?.loadWebPage(targetURL: newsToDisplay.articles?[indexPath.row].url ?? "")
//
//        let navVC = UINavigationController(rootViewController: webView)
//
//        navVC.modalPresentationStyle = .fullScreen
//        navVC.sheetPresentationController?.prefersGrabberVisible = true
//        present(navVC,animated: true,completion: nil)
//    }
//
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        print("prefetch shall happen at: ",indexPaths)
//    }
//
//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        print("prefetch shall be cancelled at: ",indexPaths)
//    }
//
//
//    func configureRefreshControl () {
//       // Add the refresh control to your UIScrollView object.
//       tableView.refreshControl = UIRefreshControl()
//        tableView.refreshControl?.addTarget(self, action:
//                                          #selector(handleRefreshControl),
//                                          for: .valueChanged)
//    }
//
//    @objc func handleRefreshControl() {
//       // Update your content…
//
//       // Dismiss the refresh control.
//       DispatchQueue.main.async {
//          self.tableView.refreshControl?.endRefreshing()
//       }
//    }

}
