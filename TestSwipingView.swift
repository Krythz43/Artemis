//
//  HomePage.swift
//  Artemis
//
//  Created by Krithick Santhosh on 27/01/23.
//

import UIKit

class TestSwipingView : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var delegate : getNewsDelegate?
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let categoricalVC = NewsCarouselViewController(collectionViewLayout: layout)
    
        let categoryView = UIView()
        view.backgroundColor = .systemTeal
        categoryView.backgroundColor = .systemBlue
        view.addSubview(categoryView)
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -250).isActive = true
        categoryView.topAnchor.constraint(equalTo: view.topAnchor,constant: 250).isActive = true
        categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addChild(categoricalVC)
        categoryView.addSubview(categoricalVC.view)
        categoricalVC.didMove(toParent: self)
        delegate = categoricalVC
        print(delegate)
        delegate?.headlinesSearch()
        
        
    }
}
