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

class SearchResult : UIViewController {
    
    var nameTextField: UITextField = {
       let textField = UITextField()
        setupTextField(textField, placeHolder: "tennis to tentacles, you get all here")
        return textField
    }()

    var submit: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add User", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(displayResult), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        
        view.addSubview(nameTextField)
        view.addSubview(submit)
        
        setupConstaints()
    }
    
    
    @objc fileprivate func displayResult() throws {
        do {
            guard let query = nameTextField.text else {
                throw SubmitError.fieldsCannotBeNull
            }
            print("Searched Query is : ",query)
        }
        catch {
            print(error)
        }
    }

    
    fileprivate func setupConstaints() {
        nameTextField.topAnchor.constraint(equalTo: view.topAnchor,constant: 60).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        submit.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        submit.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submit.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
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
