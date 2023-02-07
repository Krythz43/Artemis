//
//  catogericalSearch.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit


protocol chooseCategoryDelegate {
    func selectedCategory(type: categories)
    func resetNews()
}

class CatogericalSearchViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let imagelist = ["bag.fill","sportscourt.fill","apps.iphone","theatermasks","stethoscope","hexagon","pawprint.fill","sparkle.magnifyingglass"]
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.backgroundColor = .systemYellow
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGreen
        return label
    }()
    
    
    
    private var collectionView : UICollectionView?
    var delegate: chooseCategoryDelegate?
    private var chosenCategory : categories = .undefined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (view.frame.size.width/4), height: view.frame.size.width/3)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.register(CatogeriesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width*(2/3))
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    @objc func setFiltersForCategories() {
        let filtersView = SourceHandlerViewController()
        filtersView.newsType = .topHeadlines
        filtersView.typeOfPage = .sources
        filtersView.title = "Sources"
        filtersView.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "plus.square.on.square.fill"), tag: 4)
        filtersView.sources = SourcesV2(sources: [])
        filtersView.fetchSources(type: .sources,category: chosenCategory)
        filtersView.title = "Set Sources"
        filtersView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSources))
        filtersView.modalPresentationStyle = .fullScreen
        filtersView.sheetPresentationController?.prefersGrabberVisible = true
        
        navigationController?.pushViewController(filtersView, animated: true)
    }
    
    @objc private func dismissSources() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CatogeriesCollectionViewCell else {
            return CatogeriesCollectionViewCell()
        }
        cell.label.text = categoryList[indexPath.row]
        cell.imageView.image = UIImage(systemName: imagelist[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        chosenCategory = categories.
        switch indexPath[1]{
            case 0: chosenCategory = .business
            case 1: chosenCategory = .sports
            case 2: chosenCategory = .technology
            case 3: chosenCategory = .entertainment
            case 4: chosenCategory = .health
            case 5: chosenCategory = .science
            case 6: chosenCategory = .general
            case 7: chosenCategory = .undefined
            default:
                print("no idea how you did this you borbon")
        }
        
        print("Value chosen was ",indexPath[1]," enum value :",chosenCategory)
        if(chosenCategory != .undefined){
            categorypicked()
        } else {
            searchResultPage()
        }
    }
    
    @objc func categorypicked() {
        let newsView =  NewsDisplayViewController()
        self.delegate = newsView.getNewsModel()
        newsView.setNewsType(newsType: .categoricalNews)
        
        print("Delegated function to be invoked :",delegate ?? "Error invoking delegate")
        delegate?.selectedCategory(type: chosenCategory)
        
        newsView.title = "Displaying news from : " + getCategory(chosenCategory)
        newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        newsView.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Set Filters", style: .plain, target: self, action: #selector(setFiltersForCategories))
        newsView.modalPresentationStyle = .pageSheet
        newsView.sheetPresentationController?.detents = [.custom(resolver: { context in
            return self.view.bounds.height*0.75
        })]
        newsView.sheetPresentationController?.prefersGrabberVisible = true
        
        navigationController?.pushViewController(newsView, animated: true)
        
    }
    
    @objc func searchResultPage() {
        let newsView =  QueriedNewsViewController()
        newsView.title = "Whats on your mind?"
        newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        newsView.modalPresentationStyle = .fullScreen
        
        let navVC = UINavigationController(rootViewController: newsView)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC,animated: true,completion: nil)
    }
    
    @objc private func dismissSelf() {
        delegate?.resetNews()
        dismiss(animated: true,completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
