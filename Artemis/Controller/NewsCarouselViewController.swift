//
//  SwipingController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 26/01/23.
//


import UIKit

protocol getNewsDelegate {
    func headlinesSearch()
}

class NewsCarouselViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var newsResult : News = News()
    var newsToDisplay = News(){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    var numberOfPages = 0
    var pageControldelegate: customPageControlDelegate?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(NewsCardCV.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = true
        startTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfPages = newsResult.articles?.count ?? 0
        print("Number of sections to be processed : ",newsResult.articles?.count ?? 0)
        pageControldelegate?.setPages(numberOfPages: self.numberOfPages)
        return self.numberOfPages
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? NewsCardCV else {
            return NewsCardCV()
        }
        cell.layer.cornerRadius = 15
        let newsArticle = newsResult.articles?[indexPath.row]
        cell.set(res : newsArticle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webView = BrowserViewController()
        var delegate: webViewDelegate?
        delegate = webView
        delegate?.loadView()
        
        webView.title = newsToDisplay.articles?[indexPath.row].source?.name ?? ""
        webView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(dismissBrowserView))
        delegate?.loadWebPage(targetURL: newsToDisplay.articles?[indexPath.row].url ?? "")
        
        let navVC = UINavigationController(rootViewController: webView)
        
        navVC.modalPresentationStyle = .fullScreen
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        present(navVC,animated: true,completion: nil)
    }
    
    @objc private func dismissBrowserView() {
        dismiss(animated: true,completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("current page is: ",calculateCurrentPage())
        pageControldelegate?.setCurrentPage(currentPage: calculateCurrentPage())
    }
    
    private func calculateCurrentPage() -> Int {
        return Int((collectionView.contentOffset.x+collectionView.frame.width - 1)/collectionView.frame.width)
    }
}

private typealias invokeHeadLinesSearch = NewsCarouselViewController
extension invokeHeadLinesSearch: getNewsDelegate{
    func headlinesSearch() {
        print("Everything search invoked",self.newsToDisplay)
        fetchNews(type: .everything)
    }
}

private typealias setupCarouselMoveAnimation = NewsCarouselViewController
extension setupCarouselMoveAnimation {
    @objc func scrollToNextCell(){
        let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
        let contentOffset = collectionView.contentOffset;
        if(cellSize.width*CGFloat(numberOfPages - 1) >= contentOffset.x + cellSize.width){
            collectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
            
        } else {
            print("Attempt to bring back to start")
            collectionView.scrollToItem(at: [0,-1], at: UICollectionView.ScrollPosition.left, animated: true);
        }
    }

    func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true);
    }
}
