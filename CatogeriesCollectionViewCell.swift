//
//  CatogeriesCollectionViewCell.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

class CatogeriesCollectionViewCell: UICollectionViewCell {
    static let identifier = "CatogeriesCollectionViewCell"
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sportscourt")
        imageView.backgroundColor = .secondarySystemFill
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "House"
        label.backgroundColor = .systemGreen
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemFill
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        imageView.frame = CGRect(x: 5, y: 0, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 50)
    }
}
