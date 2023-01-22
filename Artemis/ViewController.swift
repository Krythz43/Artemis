//
//  ViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 11/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    var newsResult : News = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBlue
        
        Networking.sharedInstance.getNews(type: .everything){[weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let newsResult):
                self?.newsResult = newsResult
            }
        }
        
        print(newsResult)
        
    }
}

