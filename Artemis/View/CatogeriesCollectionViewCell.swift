//
//  CatogeriesCollectionViewCell.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

class CatogeriesCollectionViewCell: UICollectionViewCell {
    static let identifier = "CatogeriesCollectionViewCell"
    
    let containerView : UIView = {
        let view = UIView()
//        view.layer.cornerRadius = 5
//        view.layer.borderColor = CGColor(gray: 0, alpha: 0.5)
//        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        view.tintColor = .white
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sportscourt")
        imageView.layer.cornerRadius = 5
//        imageView.backgroundColor = .secondarySystemFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "House"
//        label.backgroundColor = .systemOrange
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.addSubview(containerView)
        addSubview(label)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 3).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor,multiplier: 0.7).isActive = true
        
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
//        containerView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
//        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 100)
    }
}
