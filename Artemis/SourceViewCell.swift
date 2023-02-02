//
//  SourceViewCell.swift
//  Artemis
//
//  Created by Krithick Santhosh on 02/02/23.
//

import UIKit

protocol singularSourceDelegate{
    func getSourceNews(type: APICalls,source: String)
    func resetNews()
}
class SourceViewCell: UITableViewCell {
    var sourcesBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
//        view.axis = NSLayoutConstraint.Axis.vertical
//        view.backgroundColor = UIColor.secondarySystemBackground
        view.backgroundColor = .systemGreen
        view.clipsToBounds = true
        return view
    }()
    
    var sourcesTitle: UILabel = {
       let title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 15)
        title.numberOfLines = 0
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(sourcesBackground)
        sourcesBackground.addSubview(sourcesTitle)
        
        sourcesBackgroundConstraints()
        sourceNameConstraints()
//        newsDescriptionConstraints()
//        authorNameConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    fileprivate func sourcesBackgroundConstraints () {
        sourcesBackground.translatesAutoresizingMaskIntoConstraints = false
        sourcesBackground.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        sourcesBackground.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        cardBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        sourcesBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        sourcesBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    fileprivate func sourceNameConstraints() {
        sourcesTitle.translatesAutoresizingMaskIntoConstraints = false
        sourcesTitle.centerXAnchor.constraint(equalTo: sourcesBackground.centerXAnchor).isActive = true
        sourcesTitle.centerYAnchor.constraint(equalTo: sourcesBackground.centerYAnchor).isActive = true
    }
    
    func set(res: Source?){
        sourcesTitle.text = res?.name
    }
}
