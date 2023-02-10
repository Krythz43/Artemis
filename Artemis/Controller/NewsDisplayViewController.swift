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

class NewsDisplayViewController :UITableViewController{
    
    private var delegate: webViewDelegate?
    var notFoundDelegate: setNewsNotFoundDelegate?
    private var viewModel =  NewsViewModel()
    
    fileprivate func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsCard.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 420
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tintColor = .white
        configureRefreshControl()
        
        viewModel.newsDisplayDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Type of news called: ",viewModel.getCurrentNewsPageType())
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of sections to be processed : ",viewModel.getNewsToBeDisplay().articles?.count ?? 0)
        let newsCount = viewModel.getNewsToBeDisplay().articles?.count ?? 0
        viewModel.setNewsArticlesCount(count: newsCount)
        notFoundDelegate?.setNewsStatus(newsCount: newsCount)
        print("DElegtaevdtwvdywyewbue status: ", notFoundDelegate)
        return newsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? NewsCard else {
            return NewsCard()
        }
    
        guard indexPath.row < viewModel.getNewsToBeDisplay().articles?.count ?? 0 else {
            return NewsCard()
        }
        
        
        guard let newsArticle = viewModel.getNewsToBeDisplay().articles?[indexPath.row] else {
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
        
        webView.title = viewModel.getNewsToBeDisplay().articles?[indexPath.row].source?.name ?? ""
        
        webView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(dismissSelf))

        print("Url to display : ", viewModel.getNewsToBeDisplay().articles?[indexPath.row].url ?? "")
        delegate?.loadWebPage(targetURL: viewModel.getNewsToBeDisplay().articles?[indexPath.row].url ?? "")
//        let navVC = UINavigationController(rootViewController: webView)
//
//        navVC.modalPresentationStyle = .fullScreen
//        navVC.sheetPresentationController?.prefersGrabberVisible = true
//        present(navVC,animated: true,completion: nil)
        navigationController?.pushViewController(webView, animated: true)
    }
    
    @objc private func dismissSelf() {
//        dismiss(animated: true,completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func getNewsViewModel() -> NewsViewModel {
        return self.viewModel
    }
    
    func setNewsType(newsType: displayedNewsType) {
        viewModel.setNewsType(newsType: newsType)
    }
}


private typealias setupPullToRefresh = NewsDisplayViewController
extension setupPullToRefresh {
    func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        viewModel.refreshBasedOnNewsType()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

private typealias setupInfiniteScroll = NewsDisplayViewController
extension setupInfiniteScroll {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("news about to be displayed: ",indexPath)
        
        if(indexPath.row > viewModel.getPageLimit()){
            viewModel.incrementPageLimit()
            viewModel.incrementPageNumber()
            viewModel.setNewsAppendingStatus(shouldNewsBeAppended: true)
            viewModel.loadMorePages(pageNumber: viewModel.getCurrentPage())
        }
    }
}

extension NewsDisplayViewController: NewsViewDelegate {
    func getTableView() -> UITableView {
        return self.tableView
    }
}

extension NewsDisplayViewController: UITextFieldDelegate{

}
