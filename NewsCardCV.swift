//
//  NewsCard.swift
//  Artemis
//
//  Created by Krithick Santhosh on 27/01/23.
//

import UIKit

class NewsCardCV : UICollectionViewCell {
    
    /*
        From the API We use
     
        1) url for Image
        2) Title
        3) description
        4) Author Name
        5) Published ago
     */
    
    var cardBackground : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
//        view.axis = NSLayoutConstraint.Axis.vertical
        view.backgroundColor = UIColor.secondarySystemBackground
        view.clipsToBounds = true
        return view
    }()
    
    var newsTitle: UILabel = {
       let title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 25)
        return title
    }()
    
    var authorName: UILabel = {
        let name = UILabel()
        name.adjustsFontSizeToFitWidth = true
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.systemFont(ofSize: 20)
        name.textColor = UIColor.secondaryLabel
        return name
    }()
    
    var newsDescription : UILabel = {
        let description = UILabel()
        description.adjustsFontSizeToFitWidth = true
        description.translatesAutoresizingMaskIntoConstraints = false
        description.font = UIFont.systemFont(ofSize: 20)
        description.textColor = UIColor.secondaryLabel
        return description
    }()
    
    var newsImage : UIImageView = {
        let nImage = UIImageView()
        nImage.translatesAutoresizingMaskIntoConstraints = false
        nImage.clipsToBounds = true
        return nImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cardBackground)
        addSubview(newsImage)
        addSubview(newsTitle)
        addSubview(newsDescription)
        addSubview(authorName)

//        cardBackground.addArrangedSubview(newsImage)
//        cardBackground.addArrangedSubview(newsTitle)
//        cardBackground.addArrangedSubview(newsDescription)
//        cardBackground.addArrangedSubview(authorName)
        
        cardBackgroundConstraints()
        newsImageConstraints()
        newsTitleConstraints()
        newsDescriptionConstraints()
        authorNameConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    fileprivate func cardBackgroundConstraints () {
        cardBackground.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        cardBackground.heightAnchor.constraint(equalToConstant: 400).isActive = true
//        cardBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        cardBackground.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        cardBackground.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    fileprivate func newsImageConstraints() {
        newsImage.heightAnchor.constraint(equalTo: cardBackground.heightAnchor, multiplier: 0.7).isActive = true
        newsImage.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 16).isActive = true
        newsImage.topAnchor.constraint(equalTo: cardBackground.topAnchor,constant: 16).isActive = true
        newsImage.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor,constant: -16).isActive = true
    }
    
    fileprivate func newsTitleConstraints() {
        newsTitle.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 14).isActive = true
        newsTitle.heightAnchor.constraint(equalToConstant: 25).isActive  = true
        newsTitle.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 30).isActive = true
        newsTitle.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor ).isActive = true
    }
    
    fileprivate func newsDescriptionConstraints() {
        newsDescription.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 5).isActive = true
        newsDescription.heightAnchor.constraint(equalToConstant: 40).isActive  = true
        newsDescription.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 30).isActive = true
        newsDescription.widthAnchor.constraint(equalTo: cardBackground.widthAnchor ).isActive = true
    }
    
    fileprivate func authorNameConstraints() {
        authorName.topAnchor.constraint(equalTo: newsDescription.bottomAnchor , constant:10).isActive = true
        authorName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        authorName.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 30).isActive = true
        authorName.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -10).isActive = true
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.newsImage.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func set(res: Articles?){
        newsTitle.text = res?.title
        newsDescription.text = res?.description
        guard let _ = res?.urlToImage else {
            return
        }
        
        let url = URL(string: (res?.urlToImage)!)
        
        guard let _ = url else {
            return
        }
        downloadImage(from: url!)
    }
}
