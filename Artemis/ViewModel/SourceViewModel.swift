//
//  SourceViewModel.swift
//  Artemis
//
//  Created by Krithick Santhosh on 07/02/23.
//

import Foundation
import UIKit


protocol sourceViewDelegate: AnyObject {
    func getSourceTableView() -> UITableView
}

class SourceViewModel {
    weak var sourceFilterdelegate: sourceViewDelegate?
    private var categorySelected : categories = .undefined
    
    var typeOfPage: pages = .undefined
    var newsType: displayedNewsType = .undefined
    
    private var sourceName: String = ""
    private var sourceId: String = ""
    
    var sources = SourcesV2(sources: []){
        didSet {
            print("Sources was modified")
            DispatchQueue.main.async {
                self.sourceFilterdelegate?.getSourceTableView().reloadData()
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
    
    func getSources() -> SourcesV2 {
        return sources
    }
    
    func setCategorySelected(category: categories){
        self.categorySelected = category
    }
    
    func getCategorySelected() -> categories{
        return categorySelected
    }
    
    func resetCatergoriesView(){
        sources = SourcesV2(sources: [])
        for category in categoryList {
            sources.sources?.append(Source(name: category))
        }
    }
    
    func setNewsType(newsType: displayedNewsType) {
        self.newsType = newsType
    }
    
    func getNewsType() -> displayedNewsType{
        return newsType
    }
    
    func getPageType() -> pages {
        return typeOfPage
    }
    
    func setPageType(page: pages){
        typeOfPage = page
    }
    
    func setSourceDetails(name: String? = "",id: String? = ""){
        sourceName = name ?? ""
        sourceId = id ?? ""
    }
    
    func getSournceName() -> String {
        return sourceName
    }
    
    func getSourceId() -> String {
        return sourceId
    }
    
    func resetSources(){
        sources = SourcesV2(sources: [])
    }
    
    func populateSources(){
        if(typeOfPage == .sources){
            fetchSources(type: .sources,category: categorySelected)
        }
        else{
            for category in categoryList {
                sources.sources?.append(Source(name: category))
            }
        }
    }
}

extension SourceViewModel: fetchSourcesDelegate {
    func fetchCategoricalSources(type: APICalls,category: categories){
        fetchSources(type: .sources,category: self.categorySelected)
    }
}
