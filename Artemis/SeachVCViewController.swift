//
//  SeachVCViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

class SeachVCViewController: UIViewController {

    private var artemisTitleView = UIImageView()
    private var globeImage = UIImageView()
    private let button = UIButton()
    private var topControlsStackView =  UIStackView()
    private let headlinesView = UIView()
    private let categoryController = CatogericalSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        artemisTitleView = UIImageView(image: UIImage(named: "artemisLogo"))
        artemisTitleView.contentMode = .scaleAspectFill
//        artemisTitleView.clipsToBounds = true
        
        globeImage = UIImageView(image: UIImage(named: "earthIcon"))
        topControlsStackView = UIStackView(arrangedSubviews: [artemisTitleView,globeImage])
        view.addSubview(topControlsStackView)
        view.addSubview(button)
        button.setImage(UIImage(named: "earthIcon"), for: .normal)
        
        
        
        addChild(categoryController)
        view.addSubview(categoryController.view)
        categoryController.didMove(toParent: self)
        categoryController.view.backgroundColor = .systemTeal
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let headlinesContainer = SwipingController(collectionViewLayout: layout)
        addChild(headlinesContainer)
        
        
        view.addSubview(headlinesView)
        headlinesView.addSubview(headlinesContainer.view)
        headlinesContainer.didMove(toParent: self)
        
        
        var delegate : getNewsDelegate?
        delegate = headlinesContainer
        delegate?.headlinesSearch()
        
        
        setupTopControlStack()
        setUpButton()
        setupConstraints()
    }
    
    fileprivate func setupTopControlStack(){
        artemisTitleView.backgroundColor = .systemRed
    }
    
    fileprivate func setUpButton(){
//        button.setTitle("News across the globe", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        let rootVC = MapScene()
        rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        rootVC.title = "Map View"
        button.setImage(UIImage(), for: .normal)
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .flipHorizontal
        
        present(navVC,animated: true)
    }
    
    @objc private func dismissSelf() {
        button.setImage(UIImage(named: "earthIcon"), for: .normal)
        dismiss(animated: true,completion: nil)
    }
    
    fileprivate func setupConstraints(){
        
        topControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        topControlsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: -20).isActive = true
        topControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: -60).isActive = true
        topControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topControlsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: globeImage.trailingAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: globeImage.leadingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: globeImage.bottomAnchor).isActive = true
        button.topAnchor.constraint(equalTo: globeImage.topAnchor).isActive = true
        
        categoryController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            categoryController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            categoryController.view.topAnchor.constraint(equalTo: topControlsStackView.bottomAnchor, constant: 10),
            categoryController.view.heightAnchor.constraint(equalToConstant: view.frame.size.width*(2/3))
            ])
        
        artemisTitleView.translatesAutoresizingMaskIntoConstraints = false
        artemisTitleView.topAnchor.constraint(equalTo: topControlsStackView.topAnchor).isActive = true
        artemisTitleView.bottomAnchor.constraint(equalTo: topControlsStackView.bottomAnchor).isActive = true
        artemisTitleView.leadingAnchor.constraint(equalTo: topControlsStackView.leadingAnchor).isActive = true
        artemisTitleView.widthAnchor.constraint(equalTo: topControlsStackView.widthAnchor, multiplier: 0.8).isActive = true
        
        headlinesView.translatesAutoresizingMaskIntoConstraints = false
        headlinesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10).isActive = true
        headlinesView.topAnchor.constraint(equalTo: categoryController.view.bottomAnchor,constant: 10).isActive = true
        headlinesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headlinesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}
