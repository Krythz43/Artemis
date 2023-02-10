//
//  SeachVCViewController.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

protocol customPageControlDelegate: AnyObject {
    func setPages(numberOfPages: Int)
    func setCurrentPage(currentPage: Int)
}

class HomePageViewController: UIViewController {
    
    private var artemisTitleView = UIImageView()
    private var globeImage = UIImageView()
    private let button = UIButton()
    private var topControlsStackView =  UIStackView()
    private let headlinesView = UIView()
    private let categoryController = CatogericalSearchViewController()
    private var headlinesNavigationBar = UINavigationBar()
    private var categoriesHeaderBar = UINavigationBar()
    
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 20
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = .gray
        pc.allowsContinuousInteraction = false
        return pc
    }()
    
    var nameTextField: UITextField = {
       let textField = UITextField()
        setupTextField(textField, placeHolder: "Search news about...")
        return textField
    }()
    
    private weak var delegate : getNewsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setupLayout() {
        searchFieldLayout()
        self.navigationController?.navigationBar.isHidden = true
        categoriesLayoutSetup()
        carouselBehaviourSetup()
        setCategoriesHeaderBar()
        setNavigationBar()
        setupTopControlStack()
        setUpButton()
        setupConstraints()
    }
    
    fileprivate func searchFieldLayout(){
        nameTextField.delegate = self
        topControlsStackView = UIStackView(arrangedSubviews: [nameTextField])
        view.addSubview(topControlsStackView)
    }
    
    fileprivate func categoriesLayoutSetup() {
        addChild(categoryController)
        view.addSubview(categoryController.view)
        categoryController.didMove(toParent: self)
        categoryController.view.backgroundColor = .systemTeal
    }
    
    fileprivate func carouselBehaviourSetup(){
        let headlinesContainer = carouselLayout()
        headlinesView.addSubview(headlinesContainer.view)
        view.addSubview(pageControl)
    }
    
    fileprivate func carouselLayout() -> NewsCarouselViewController {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let headlinesContainer = NewsCarouselViewController(collectionViewLayout: layout)
        
        weak var delegate: getNewsDelegate?
        delegate = headlinesContainer.getNewsViewModel()
        delegate?.headlinesSearch()
        
        addChild(headlinesContainer)
        view.addSubview(headlinesView)
        headlinesView.addSubview(headlinesContainer.view)
        headlinesContainer.didMove(toParent: self)
        headlinesContainer.pageControldelegate = self
        view.addSubview(pageControl)
        headlinesConstraints(headlinesContainer)
        return headlinesContainer
    }
    
    func headlinesConstraints(_ headlinesContainer: NewsCarouselViewController) {
        headlinesContainer.view.translatesAutoresizingMaskIntoConstraints = false
        headlinesContainer.view.leadingAnchor.constraint(equalTo: headlinesView.leadingAnchor).isActive = true
        headlinesContainer.view.trailingAnchor.constraint(equalTo: headlinesView.trailingAnchor).isActive = true
        headlinesContainer.view.topAnchor.constraint(equalTo: headlinesView.topAnchor).isActive = true
        headlinesContainer.view.bottomAnchor.constraint(equalTo: headlinesView.bottomAnchor).isActive = true
    }
    
    func setCategoriesHeaderBar() {
        let navItem = UINavigationItem(title: "What's on your mind today?")
        categoriesHeaderBar.barTintColor = .white
        categoriesHeaderBar.setItems([navItem], animated: false)
        self.view.addSubview(categoriesHeaderBar)
    }
    
    func setNavigationBar() {
        let navItem = UINavigationItem(title: "Top Headlines")
        let doneItem = UIBarButtonItem(title: "view more", style: .plain, target: self, action: #selector(seeAllTopHeadlines))
        navItem.rightBarButtonItem = doneItem
        headlinesNavigationBar.barTintColor = .white
        headlinesNavigationBar.setItems([navItem], animated: false)
        self.view.addSubview(headlinesNavigationBar)
    }
    
    @objc func seeAllTopHeadlines() {
        let newsView =  NewsDisplayViewController()
        delegate = newsView.getNewsViewModel()
        newsView.setNewsType(newsType: .topHeadlines)
        
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
        let filtersView = SourceHandlerViewController()
        
        let sourcesViewModel = filtersView.getSourcesViewModel()
        sourcesViewModel.setNewsType(newsType: .topHeadlines)
        sourcesViewModel.setPageType(page: .category)
        sourcesViewModel.resetSources()
        sourcesViewModel.populateSources()
        
        filtersView.title = "Sources"
        filtersView.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "plus.square.on.square.fill"), tag: 4)
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
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func dismissSources() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapButton() {
        let rootVC = MapsSceneViewController()
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
        headlinesNavBarConstraints()
        controlsStackConstraints()
        nameTextFieldConstraints()
        categoriesConstraints()
        categoriesHeaderConstraints()
        headlinesViewConstraints()
        pageControlConstraints()
    }
    
    func headlinesNavBarConstraints(){
        headlinesNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        headlinesNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        headlinesNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        headlinesNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        headlinesNavigationBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }
    
    func controlsStackConstraints(){
        topControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        topControlsStackView.topAnchor.constraint(equalTo: headlinesNavigationBar.bottomAnchor,constant: 10).isActive = true
        topControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topControlsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04).isActive = true
    }
    
    func nameTextFieldConstraints(){
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.topAnchor.constraint(equalTo: topControlsStackView.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: topControlsStackView.bottomAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: topControlsStackView.leadingAnchor,constant: 7).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -7).isActive = true
    }
    
    func categoriesConstraints(){
        categoryController.view.translatesAutoresizingMaskIntoConstraints = false
        categoryController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        categoryController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoryController.view.heightAnchor.constraint(equalToConstant:  view.frame.size.width*(2/3) - 20).isActive = true
    }
    
    func categoriesHeaderConstraints(){
        categoriesHeaderBar.translatesAutoresizingMaskIntoConstraints = false
        categoriesHeaderBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoriesHeaderBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoriesHeaderBar.bottomAnchor.constraint(equalTo: categoryController.view.topAnchor,constant: -7).isActive = true
        categoriesHeaderBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }
    
    func headlinesViewConstraints(){
        headlinesView.translatesAutoresizingMaskIntoConstraints = false
        headlinesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headlinesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headlinesView.topAnchor.constraint(equalTo: topControlsStackView.bottomAnchor,constant: 0).isActive = true
        headlinesView.bottomAnchor.constraint(equalTo: pageControl.topAnchor).isActive = true
    }
    
    func pageControlConstraints(){
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: categoriesHeaderBar.topAnchor,constant: -7).isActive=true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }

}

extension HomePageViewController: customPageControlDelegate{
    func setPages(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    func setCurrentPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}

private typealias redirectSearchFieldToSearchView = HomePageViewController
extension redirectSearchFieldToSearchView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Redirecting to search screen")
        let searchView = QueriedNewsViewController()
        searchView.title = "News Search"
        searchView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSources))
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(searchView, animated: true)
        return false
    }
    
    @objc func dismissSearchPage(){
        navigationController?.popViewController(animated: true)
    }
}
