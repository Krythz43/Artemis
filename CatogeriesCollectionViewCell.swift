//
//  CatogeriesCollectionViewCell.swift
//  Artemis
//
//  Created by Krithick Santhosh on 19/01/23.
//

import UIKit

class CatogeriesCollectionViewCell: UICollectionViewCell {
    static let identifier = "CatogeriesCollectionViewCell"
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.backgroundColor = .systemYellow
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "House"
        label.backgroundColor = .systemGreen
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBlue
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 5, y: contentView.frame.size.height - 50, width: contentView.frame.size.width - 10, height: 50)
        imageView.frame = CGRect(x: 5, y: 0, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 50)
    }
}
