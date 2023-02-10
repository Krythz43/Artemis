//
//  SwipingController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 26/01/23.
//


import UIKit

protocol getNewsDelegate: AnyObject {
    func headlinesSearch()
}

class NewsCarouselViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    private var viewModel =  NewsViewModel()
    var pageControldelegate: customPageControlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setNewsForCollectionView()
        viewModel.newsDisplayCVDelegate = self
        
        collectionView.backgroundColor = .white
        collectionView.register(NewsCardCV.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = true
        collectionView.tintColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        startTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let newsCount = viewModel.getNewsToBeDisplay().articles?.count ?? 0
        print("Number of sections to be processed : ",newsCount)
        viewModel.setNewsArticlesCount(count: newsCount)
        pageControldelegate?.setPages(numberOfPages: newsCount)
        return newsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? NewsCardCV else {
            return NewsCardCV()
        }
        cell.layer.cornerRadius = 15
        let newsArticle = viewModel.getNewsToBeDisplay().articles?[indexPath.row]
        cell.set(res : newsArticle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
//        return collectionView.sizeThatFits(CGSize(width: view.frame.width, height: view.frame.height))
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webView = BrowserViewController()
        var delegate: webViewDelegate?
        delegate = webView
        delegate?.loadView()
        
        webView.title = viewModel.getNewsToBeDisplay().articles?[indexPath.row].source?.name ?? ""
        webView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(dismissBrowserView))
        delegate?.loadWebPage(targetURL: viewModel.getNewsToBeDisplay().articles?[indexPath.row].url ?? "")
        
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

private typealias setupCarouselMoveAnimation = NewsCarouselViewController
extension setupCarouselMoveAnimation {
    @objc func scrollToNextCell(){
        let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
        let contentOffset = collectionView.contentOffset;
        if(cellSize.width*CGFloat(viewModel.getNewsArticlesCount() - 1) >= contentOffset.x + cellSize.width){
            collectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
            
        } else {
            print("Attempt to bring back to start")
            collectionView.scrollToItem(at: [0,-1], at: UICollectionView.ScrollPosition.left, animated: true);
        }
    }

    func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true);
    }
    
    func getNewsViewModel() -> NewsViewModel {
        return self.viewModel
    }
}

extension NewsCarouselViewController: NewsViewCVDelegate {
    func getCollectionView() -> UICollectionView {
        return self.collectionView
    }
}
