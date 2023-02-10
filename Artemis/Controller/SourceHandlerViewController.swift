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

protocol fetchSourcesDelegate : AnyObject{
    func fetchCategoricalSources(type: APICalls,category: categories)
}

class SourceHandlerViewController: UITableViewController {

    private var viewModel = SourceViewModel()
    var searchView: NewsDisplayViewController = NewsDisplayViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    weak var newsFetchDelegate: categorySourceDelegate?
    private weak var setFiltersdelegate: setFiltersDelegate?
    private weak var refreshNewsDelegate: refreshNewsDelegate?
    var searchFilterDelegate : setSearchFilterDelegate?
    
    fileprivate func setupTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SourceHandlerViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        viewModel.sourceFilterdelegate = self
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    ove
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfSections = viewModel.getSources().sources?.count ?? 0
//        pageControl.numberOfPages = numberOfSections
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Setting something")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SourceHandlerViewCell else {
            return SourceHandlerViewCell()
        }

        cell.layer.cornerRadius = 15
        guard let name = viewModel.getSources().sources?[indexPath.row] else {
            print("Index not available yet")
            return SourceHandlerViewCell()
        }
        print("The obtained results are : ",name)
        cell.set(res : name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("The sources tab was accessed at :",indexPath)
        
        if(viewModel.getPageType() == .sources)
        {
            navigationController?.popViewController(animated: true)
            var newsView = navigationController?.topViewController as? NewsDisplayViewController
            if(viewModel.getNewsType() == .searchNews){
                newsView = NewsDisplayViewController()
            }
            
            let newsViewModel = newsView?.getNewsViewModel()
            self.newsFetchDelegate = newsViewModel
            self.setFiltersdelegate = newsViewModel
            self.refreshNewsDelegate = newsViewModel
            
            print("Delegates were set:" ,self.newsFetchDelegate, self.setFiltersdelegate)
            
            viewModel.setSourceDetails(
                name: viewModel.getSources().sources?[indexPath.row].name,
                id: viewModel.getSources().sources?[indexPath.row].id
            )
            
            let sourceName = viewModel.getSournceName()
            let sourceId = viewModel.getSourceId()
            
            let categorySelected = viewModel.getCategorySelected()
            setFiltersdelegate?.setSourceId(sourceId: sourceId)
            setFiltersdelegate?.setSourceName(sourceName: sourceName)
            setFiltersdelegate?.setCategory(category: categorySelected)
            
            if(viewModel.getNewsType() == .topHeadlines){
                print("CAlling SOURCE ")
                refreshNewsDelegate?.refreshNews(callType: .sourceSearch, category: categorySelected, sourceName: sourceId,page: 1)
            }
            else if(viewModel.getNewsType() == .searchNews){
                print("CALLING SEAVHCHCHCHC")
                print("Search filter deleagte ,",searchFilterDelegate)
                searchFilterDelegate?.setCategory(category: categorySelected)
                searchFilterDelegate?.setSource(source: sourceId)
                refreshNewsDelegate?.refreshNews(callType: .querySearch, category: categorySelected, sourceName: sourceId,page: 1)
            }
            else if (viewModel.getNewsType() == .categoricalNews) {
                print("CALLING CATEGORYRYRYRYR")
                refreshNewsDelegate?.refreshNews(callType: .categoricalSearch, category: categorySelected, sourceName: sourceId,page: 1)
            }
            else {
                print("UNDEFFEINEDEDNEINDENDEJUDN NEWS")
                print("UNDEFINED NEWS")
            }
            newsView?.title = sourceName
        }
        else {
            let categorySelected = getCategoryAt(index: indexPath.row)
            viewModel.setCategorySelected(category: categorySelected)
            var vcArray = self.navigationController?.viewControllers
            print("View controllers array :",vcArray)
            
            if(viewModel.getNewsType() == .geopraphicNews){
                print("calling GEOGRAPHIC")
                navigationController?.popViewController(animated: true)
                let newsView = navigationController?.topViewController as? NewsDisplayViewController
                self.setFiltersdelegate = newsView?.getNewsViewModel()
                self.refreshNewsDelegate = newsView?.getNewsViewModel()
                setFiltersdelegate?.setCategory(category: categorySelected)
                refreshNewsDelegate?.refreshNews(callType: .geoSearch, category: categorySelected,sourceName: "",page: 1)
                return
            }
            
            viewModel.fetchSources(type: .sources,category: viewModel.getCategorySelected())
            weak var delegate: fetchSourcesDelegate?
            delegate = viewModel
            viewModel.setPageType(page: .sources)
        }
    }
    
    @objc func popViewController(){
        print("Popping the view controller")
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCategoryAt(index: Int) -> categories {
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
        viewModel.resetCatergoriesView()
        viewModel.setPageType(page: .category)
    }
    
    func getSourcesViewModel() -> SourceViewModel {
        return self.viewModel
    }
    
    func setNewsType(type: displayedNewsType){
        viewModel.setNewsType(newsType: type)
    }
}

extension SourceHandlerViewController: sourceViewDelegate {
    func getSourceTableView() -> UITableView {
        return self.tableView
    }
}
