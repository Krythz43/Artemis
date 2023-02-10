//
//  view.swift
//  Artemis
//
//  Created by Krithick Santhosh on 10/02/23.
//

import Foundation
import UIKit

class NewsNotFoundView: UIViewController {
    
    var newsNotFoundImage : UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "tortoise.fill"))
        return image
    }()
    
    let newsNotFoundLabel : UILabel = {
        var newsNotFoundLabel =  UILabel()
        newsNotFoundLabel.text = "News Not found for the set parameters"
        newsNotFoundLabel.numberOfLines = .zero
        return newsNotFoundLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(newsNotFoundImage)
        view.addSubview(newsNotFoundLabel)
        
        newsNotFoundImage.translatesAutoresizingMaskIntoConstraints = false
        newsNotFoundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newsNotFoundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -50).isActive = true
        newsNotFoundImage.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.6).isActive = true
        newsNotFoundImage.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.4).isActive = true
        
        newsNotFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        newsNotFoundLabel.centerXAnchor.constraint(equalTo: newsNotFoundImage.centerXAnchor).isActive = true
        newsNotFoundLabel.topAnchor.constraint(equalTo: newsNotFoundImage.bottomAnchor).isActive = true
//        newsNotFoundLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
    }
}
