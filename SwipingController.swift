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

class SwipingController: UICollectionViewController,UICollectionViewDelegateFlowLayout, getNewsDelegate {
    
    var newsResult : News = News()
    var newsToDisplay = News(){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    func headlinesSearch() {
        print("Everything search invoked",self.newsToDisplay)
        fetchNews(type: .everything)
    }
    
    func fetchNews(type: APICalls,category: categories = .undefined, query : String = "",countryCode : String = "") {
        Networking.sharedInstance.getNews(type: type, category: category, query: query,countryCode: countryCode){[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newsResult):
                print("API CALL WAS SUCESS1", newsResult.articles?[0])
                self?.newsResult = newsResult
                self?.newsToDisplay = newsResult
                
                //                print("API CALL WAS SUCESS2", self.newsToDisplay, self.x)
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of sections to be processed : ",newsResult.articles?.count ?? 0)
        return newsResult.articles?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? NewsCardCV else {
            return NewsCardCV()
        }
        // we cant directly use this because its an UI something and cant be used for properties
        
        //        cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .green
        cell.layer.cornerRadius = 15
        let newsArticle = newsResult.articles?[indexPath.row]
        cell.set(res : newsArticle)
        print("The obtained results are : ",newsArticle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item selected at collection view at : ",indexPath)
        let webView = BrowserViewController()
        var delegate: webViewDelegate?
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

