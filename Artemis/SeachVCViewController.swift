//
//  SeachVCViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

protocol customPageControlDelegate {
    func setPages(numberOfPages: Int)
    func setCurrentPage(currentPage: Int)
}

class SeachVCViewController: UIViewController, customPageControlDelegate {
    func setPages(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    func setCurrentPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    

    private var artemisTitleView = UIImageView()
    private var globeImage = UIImageView()
    private let button = UIButton()
    private var topControlsStackView =  UIStackView()
    private let headlinesView = UIView()
    private let categoryController = CatogericalSearch()
    private var headlinesNavigationNar = UINavigationBar()
    
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 20
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = .gray
        pc.allowsContinuousInteraction = false
        return pc
    }()
    
    private var delegate : getNewsDelegate?
    
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
        self.setNavigationBar()

        
        view.addSubview(headlinesView)
        headlinesView.addSubview(headlinesContainer.view)
        headlinesContainer.didMove(toParent: self)
        headlinesContainer.pageControldelegate = self
        view.addSubview(pageControl)
        
        var delegate : getNewsDelegate?
        delegate = headlinesContainer
        delegate?.headlinesSearch()
        
        
        setupTopControlStack()
        setUpButton()
        setupConstraints()
    }
    
    func setNavigationBar() {
        let navItem = UINavigationItem(title: "Top Headlines")
        let doneItem = UIBarButtonItem(title: "view more", style: .plain, target: self, action: #selector(seeAllTopHeadlines))
        navItem.rightBarButtonItem = doneItem
        headlinesNavigationNar.backgroundColor = .systemGray
        headlinesNavigationNar.setItems([navItem], animated: false)
        self.view.addSubview(headlinesNavigationNar)
    }

    @objc func seeAllTopHeadlines() {
        let newsView =  TableViewController()
        delegate = newsView
        newsView.newsType = .topHeadlines
        
        print("Delegated function to be invoked :",delegate ?? "Error invoking delegate")
        delegate?.headlinesSearch()
        
        newsView.title = "Top Headlines"
        newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        newsView.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Set Filters", style: .plain, target: self, action: #selector(setFiltersHeadlines))
        newsView.modalPresentationStyle = .fullScreen
        newsView.sheetPresentationController?.prefersGrabberVisible = true
        
        navigationController?.pushViewController(newsView, animated: true)
    }
    
    @objc func setFiltersHeadlines() {
        let filtersView = SourcesList()
        filtersView.newsType = .topHeadlines
        filtersView.typeOfPage = .category
        filtersView.title = "Sources"
        filtersView.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "plus.square.on.square.fill"), tag: 4)
        filtersView.sources = SourcesV2(sources: [])
        for category in categoryList {
            filtersView.sources.sources?.append(Source(name: category))
        }
        filtersView.title = "Set Sources"
        filtersView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSources))
        filtersView.modalPresentationStyle = .fullScreen
        filtersView.sheetPresentationController?.prefersGrabberVisible = true
        
        navigationController?.pushViewController(filtersView, animated: true)
    }
    
    fileprivate func setupTopControlStack(){
        artemisTitleView.backgroundColor = .systemRed
    }
    
    fileprivate func setUpButton(){
//        button.setTitle("News across the globe", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func dismissSources() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapButton() {
        let rootVC = MapScene()
        rootVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
        rootVC.title = "Map View"
//        button.setImage(UIImage(), for: .normal)
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .flipHorizontal
        
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    @objc private func dismissSelf() {
        print("Call to dismiss")
        dismiss(animated: true,completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissSelfSecond() {
//        button.setImage(UIImage(named: "earthIcon"), for: .normal)
        dismiss(animated: true,completion: nil)
    }
    
    fileprivate func setupConstraints(){
        
        topControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        topControlsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: -20).isActive = true
        topControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: -60).isActive = true
        topControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topControlsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        
        artemisTitleView.translatesAutoresizingMaskIntoConstraints = false
        artemisTitleView.topAnchor.constraint(equalTo: topControlsStackView.topAnchor).isActive = true
        artemisTitleView.bottomAnchor.constraint(equalTo: topControlsStackView.bottomAnchor).isActive = true
        artemisTitleView.leadingAnchor.constraint(equalTo: topControlsStackView.leadingAnchor).isActive = true
        artemisTitleView.widthAnchor.constraint(equalTo: topControlsStackView.widthAnchor, multiplier: 0.8).isActive = true
        
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
            categoryController.view.heightAnchor.constraint(equalToConstant: view.frame.size.width*(2/3) - 20)
            ])
        
        headlinesView.translatesAutoresizingMaskIntoConstraints = false
        headlinesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
        headlinesView.topAnchor.constraint(equalTo: headlinesNavigationNar.bottomAnchor, constant: 0).isActive = true
        headlinesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headlinesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        headlinesNavigationNar.translatesAutoresizingMaskIntoConstraints = false
        headlinesNavigationNar.topAnchor.constraint(equalTo: categoryController.view.bottomAnchor,constant: 20).isActive = true
        headlinesNavigationNar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headlinesNavigationNar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headlinesNavigationNar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        headlinesView.translatesAutoresizingMaskIntoConstraints = false
        headlinesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headlinesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headlinesView.topAnchor.constraint(equalTo: headlinesNavigationNar.bottomAnchor,constant: -5).isActive = true
        headlinesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -3
            ).isActive=true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }

}
