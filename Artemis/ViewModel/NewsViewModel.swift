//
//  NewsViewModel.swift
//  Artemis
//
//  Created by Krithick Santhosh on 07/02/23.
//

import Foundation
import UIKit

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

protocol NewsViewDelegate {
    func getTableView() -> UITableView
}

class NewsViewModel {
    
    var newsDisplayDelegate: NewsViewDelegate?
    var newsType: displayedNewsType = .undefined
    
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
                self.newsDisplayDelegate?.getTableView().reloadData()
            }
        }
    }
    
    private var newsResult : News = News()
    
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
    
    func setNewsAppendingStatus(shouldNewsBeAppended: Bool){
        self.shouldNewsBeAppended = shouldNewsBeAppended
    }
    
    func setNewsType(newsType: displayedNewsType){
        print("News type was modified to: ",newsType)
        self.newsType = newsType
    }
    
    func getNewsToBeDisplay() -> News {
        return self.newsToDisplay
    }
    
    func getPageLimit() -> Int {
        return currentPageLimit
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func incrementPageLimit(){
        currentPageLimit += 20
    }
    
    func incrementPageNumber(){
        currentPage += 1
    }
    
    func resetNews() {
        newsToDisplay = News()
    }
    
    func getCurrentNewsPageType() -> displayedNewsType {
        return newsType
    }
}

extension NewsViewModel: chooseCategoryDelegate {
    func selectedCategory(type: categories) {
        print("The catogery of news to be displayed is : ",type)
        fetchNews(type: .categoricalSearch,category: type)
    }
}
extension NewsViewModel: querySearchDelegate{
    func querySearch(type: String,categorySelected: categories,sourceName: String) {
        print("Query search invoked with params : ",type)
        queryString = type
        fetchNews(type: .querySearch,category: categorySelected,query: type,source: sourceName)
    }
}
extension NewsViewModel: geoSearchDelegate{
    func geoSearch(countryCode : String) {
        print("Geo search invoked with params : ", countryCode)
        self.countryCode = countryCode
        fetchNews(type: .geoSearch,countryCode: countryCode)
    }
}
extension NewsViewModel: getNewsDelegate{
    func headlinesSearch() {
        print("Everything search invoked",self.newsToDisplay)
        fetchNews(type: .everything)
    }
}

extension NewsViewModel: categorySourceDelegate{
    func getCategoricalSourceNews(type: APICalls, source: String, category: categories) {
        print("Sources news invoked with params : ",source," ",category)
        fetchNews(type: .sourceSearch,category: category, source: source)
    }
}

extension NewsViewModel: setFiltersDelegate{
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
}

extension NewsViewModel: refreshNewsDelegate {
    func refreshNews(callType: APICalls, category: categories, sourceName: String = "",page : Int = 1) {
        print("REFRESH CALL HAPPENED TO :",callType," source: ",sourceName, "cc: ",countryCode, " query: ",queryString)
        fetchNews(type: callType,category: category, query: queryString,countryCode: countryCode,source: sourceName,page: page)
    }
}

