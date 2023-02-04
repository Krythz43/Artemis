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
    func querySearch(type: String)
    func resetNews()
}

class SearchResult : UIViewController, UITextFieldDelegate {
    
    var nameTextField: UITextField = {
       let textField = UITextField()
        setupTextField(textField, placeHolder: "tennis to tentacles, you get all here")
        return textField
    }()
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("The text field has been edited")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField?) {    //delegate method
        print("The text field has yet to be edited")
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("The text field wws cheanged?")
        delegate?.resetNews()
        do {
            try displayResult()
        } catch {
            print("Can't diplay results at the moment")
        }
    }
    
    var delegate : querySearchDelegate?
    var query : String = ""
    let newsContainerView = UIView()
    let newsView =  TableViewController()

    var submit: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("I'm feeling lucky", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(displayResult), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(nameTextField)
        nameTextField.delegate = self
        
        view.addSubview(submit)
        view.backgroundColor = .systemBackground
        
        newsView.newsType = .searchNews
        addChild(newsView)
        newsContainerView.backgroundColor = .systemTeal
        view.addSubview(newsContainerView)
        newsContainerView.addSubview(newsView.view)
        newsView.didMove(toParent: self)
        
        setupConstaints()
    }
    
    fileprivate func displayNews() {
        let newsView =  self.newsView
        self.delegate = newsView
        
        print("Delegated function to be invoked :",delegate ?? "Error invoking delegate")
        delegate?.querySearch(type: query)
        
//        newsView.title = "Displaying news from : " + query
//        newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(dismissSelf))
//        newsView.modalPresentationStyle = .pageSheet
//        newsView.sheetPresentationController?.detents = [.custom(resolver: { context in
//            return self.view.bounds.height*0.75
//        })]
//        newsView.sheetPresentationController?.prefersGrabberVisible = true
//
//        let navVC = UINavigationController(rootViewController: newsView)
//        present(navVC,animated: false)
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

fileprivate func setupTextField(_ textField: UITextField, placeHolder: String) {
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
}
