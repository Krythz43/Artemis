//
//  SeachVCViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

class SeachVCViewController: UIViewController {

    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(button)
        setUpButton()
        
        let categoryController = CatogericalSearch()
        addChild(categoryController)
        categoryController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryController.view)
        
        categoryController.didMove(toParent: self)
        categoryController.view.backgroundColor = .systemTeal
        NSLayoutConstraint.activate([
            categoryController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            categoryController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            categoryController.view.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 50),
            categoryController.view.heightAnchor.constraint(equalToConstant: view.frame.size.width*(2/3))
            ])
        
        
        
    }
    
    fileprivate func setUpButton(){
        button.setTitle("News across the globe", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        let rootVC = MapScene()
        rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        rootVC.title = "Map View"
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .flipHorizontal
        
        present(navVC,animated: true)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true,completion: nil)
    }

}

class SecondViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        title = "welcome"
    }
}
