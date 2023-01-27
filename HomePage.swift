//
//  HomePage.swift
//  Artemis
//
//  Created by Krithick Santhosh on 27/01/23.
//

import UIKit

class HomePage : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var delegate : getNewsDelegate?
        
        let categoricalVC = SwipingController()
        let categoryView = UIView()
        view.backgroundColor = .systemTeal
        categoryView.backgroundColor = .systemBlue
        view.addSubview(categoryView)
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -250).isActive = true
        categoryView.topAnchor.constraint(equalTo: view.topAnchor,constant: 250).isActive = true
        categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        categoryView.addSubview(categoricalVC.view)
        
        delegate = categoricalVC
        delegate?.headlinesSearch()
        
        
    }
}
