//
//  NewsView.swift
//  Artemis
//
//  Created by Krithick Santhosh on 17/01/23.
//

import UIKit

enum SubmitError: Error {
    case fieldsCannotBeNull
}

protocol querySearchDelegate {
    func querySearch(type: String, categorySelected: categories,sourceName: String)
    func resetNews()
}

protocol setSearchFilterDelegate {
    func setCategory(category: categories)
    func setSource(source: String)
}

protocol setNewsNotFoundDelegate{
    func setNewsStatus(newsCount:Int)
}

class QueriedNewsViewController: UIViewController, UITextFieldDelegate {
    
    var nameTextField: UITextField = {
       let textField = UITextField()
        setupTextField(textField, placeHolder: "tennis to tentacles, you get all here")
        return textField
    }()
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("The text field wws cheanged?")
//        delegate?.resetNews()
        do {
            try displayResult()
        } catch {
            print("Can't diplay results at the moment")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("The text field wws cheanged?")
//        delegate?.resetNews()
        do {
            try displayResult()
        } catch {
            print("Can't diplay results at the moment")
        }
    }
    
    var delegate : querySearchDelegate?
    var query : String = ""
    let newsContainerView = UIView()
    let newsView =  NewsDisplayViewController()
    let newsNotFoundView = UIView()
    
    var filterCategory: categories = .undefined
    var filterSources: String = ""

    var submit: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set Filters", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(setFiltersSearch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func setFiltersSearch() {
        let filtersView = SourceHandlerViewController()
        let sourcesViewModel = filtersView.getSourcesViewModel()
        
        sourcesViewModel.setNewsType(newsType: .searchNews)
        sourcesViewModel.setPageType(page: .category)
        sourcesViewModel.resetSources()
        sourcesViewModel.populateSources()
        
        filtersView.searchView = newsView
        filtersView.title = "Sources"
        filtersView.searchFilterDelegate = self
        filtersView.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "plus.square.on.square.fill"), tag: 4)
        
        filtersView.title = "Set Sources"
        filtersView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSources))
        filtersView.modalPresentationStyle = .fullScreen
        filtersView.sheetPresentationController?.prefersGrabberVisible = true
        
        self.navigationController?.pushViewController(filtersView, animated: true)
    }
    
    @objc private func dismissSources() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(nameTextField)
        nameTextField.delegate = self
        newsView.notFoundDelegate = self
        
        view.addSubview(submit)
        view.backgroundColor = .systemBackground
        
        newsView.setNewsType(newsType: .searchNews)
        
        newsContainerView.backgroundColor = .systemTeal
        view.addSubview(newsContainerView)
        addChild(newsView)
        newsContainerView.addSubview(newsView.view)
        newsView.didMove(toParent: self)
        setupConstaints()
        let newsNotFoundImage = UIImageView(image: UIImage(systemName: "tortoise.fill"))
        
        let newsNotFoundLabel = UILabel()
        newsNotFoundLabel.text = "News Not found for the set parameters"
        newsNotFoundLabel.numberOfLines = .zero
        view.addSubview(newsNotFoundView)
        
        newsNotFoundView.addSubview(newsNotFoundImage)
        newsNotFoundView.addSubview(newsNotFoundLabel)
        
        newsNotFoundView.translatesAutoresizingMaskIntoConstraints = false
        newsNotFoundView.trailingAnchor.constraint(equalTo: newsContainerView.trailingAnchor).isActive = true
        newsNotFoundView.leadingAnchor.constraint(equalTo: newsContainerView.leadingAnchor).isActive = true
        newsNotFoundView.topAnchor.constraint(equalTo: newsContainerView.topAnchor).isActive = true
        newsNotFoundView.bottomAnchor.constraint(equalTo: newsContainerView.bottomAnchor).isActive = true

        newsNotFoundImage.translatesAutoresizingMaskIntoConstraints = false
        newsNotFoundImage.centerXAnchor.constraint(equalTo: newsNotFoundView.centerXAnchor).isActive = true
        newsNotFoundImage.centerYAnchor.constraint(equalTo: newsNotFoundView.centerYAnchor,constant: -50).isActive = true
        newsNotFoundImage.widthAnchor.constraint(equalTo: newsNotFoundView.widthAnchor,multiplier: 0.6).isActive = true
        newsNotFoundImage.heightAnchor.constraint(equalTo: newsNotFoundView.heightAnchor,multiplier: 0.4).isActive = true
        
        newsNotFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        newsNotFoundLabel.centerXAnchor.constraint(equalTo: newsNotFoundImage.centerXAnchor).isActive = true
        newsNotFoundLabel.topAnchor.constraint(equalTo: newsNotFoundImage.bottomAnchor).isActive = true
//        newsNotFoundLabel.heightAnchor.constraint(equalTo: newsNotFoundView.heightAnchor, multiplier: 0.25).isActive = true
        
    }
    
    fileprivate func displayNews() {
        let newsView =  self.newsView
        self.delegate = newsView.getNewsViewModel()
        
        print("Delegated function to be invoked :",delegate ?? "Error invoking delegate")
        delegate?.querySearch(type: query,categorySelected: filterCategory,sourceName: filterSources)
    }
    
    @objc private func dismissSelf() {
        delegate?.resetNews()
        dismiss(animated: true,completion: nil)
    }
    
    
    @objc fileprivate func displayResult() throws {
        do {
            guard let query = nameTextField.text else {
                throw SubmitError.fieldsCannotBeNull
            }
            print("Searched Query is : ",query)
            self.query = query
            displayNews()
        }
        catch {
            print(error)
        }
    }

    
    fileprivate func setupConstaints() {
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: submit.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: submit.trailingAnchor).isActive = true
        
        submit.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        submit.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16).isActive = true
        submit.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16).isActive = true
        
        newsContainerView.translatesAutoresizingMaskIntoConstraints = false
        newsContainerView.topAnchor.constraint(equalTo: submit.bottomAnchor,constant: 30).isActive = true
        newsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        newsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}

func setupTextField(_ textField: UITextField, placeHolder: String) {
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = placeHolder
    textField.keyboardType = UIKeyboardType.default
    textField.returnKeyType = UIReturnKeyType.done
    textField.autocorrectionType = UITextAutocorrectionType.no
    textField.font = UIFont.systemFont(ofSize: 20)
    textField.textColor = UIColor.label
    textField.tintColor = UIColor.secondaryLabel
    textField.attributedPlaceholder = NSAttributedString(string: placeHolder,attributes: [NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel])
    textField.borderStyle = UITextField.BorderStyle.roundedRect
    textField.layer.borderColor = UIColor.secondaryLabel.cgColor
    textField.layer.borderWidth = 0.5
    textField.layer.cornerRadius = 5
    textField.clearButtonMode = UITextField.ViewMode.whileEditing
    textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    
    
    textField.leftViewMode = UITextField.ViewMode.always
    textField.leftViewMode = .always
    
    let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    textField.leftView = imageView;
}

private typealias setFilters = QueriedNewsViewController
extension setFilters: setSearchFilterDelegate {
    func setCategory(category: categories) {
        print("Categroy set")
        filterCategory = category
    }
    
    func setSource(source: String) {
        filterSources = source
    }
}

extension QueriedNewsViewController: setNewsNotFoundDelegate {
    func setNewsStatus(newsCount: Int) {
        newsNotFoundView.isHidden = (newsCount > 0)
        print("setting status for translates ", newsNotFoundView.isHidden)
    }
}
