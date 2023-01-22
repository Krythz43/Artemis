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

class CatogericalSearch : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView : UICollectionView?
    var delegate: chooseCategoryDelegate?
    private var chosenCategory : categories = .undefined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout( )
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
        collectionView.frame = view.bounds
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CatogeriesCollectionViewCell
        cell.contentView.backgroundColor = .systemRed
        
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
        let newsView =  TableViewController()
        self.delegate = newsView
        
        print("Delegated function to be invoked :",delegate ?? "Error invoking delegate")
        delegate?.selectedCategory(type: chosenCategory)
        
        newsView.title = "Displaying news from : " + getCategory(chosenCategory)
        newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        newsView.modalPresentationStyle = .pageSheet
        newsView.sheetPresentationController?.detents = [.custom(resolver: { context in
            return self.view.bounds.height*0.75
        })]
        newsView.sheetPresentationController?.prefersGrabberVisible = true
        
        let navVC = UINavigationController(rootViewController: newsView)
        present(navVC,animated: true)
        
    }
    @objc func searchResultPage() {
        let newsView =  SearchResult()
        newsView.title = "Whats on your mind?"
        newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        newsView.modalPresentationStyle = .fullScreen
        
        let navVC = UINavigationController(rootViewController: newsView)
        present(navVC,animated: true,completion: nil)
    }
    
    @objc private func dismissSelf() {
        delegate?.resetNews()
        dismiss(animated: true,completion: nil)
    }
}
