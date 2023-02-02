//
//  NewsCard.swift
//  Artemis
//
//  Created by Krithick Santhosh on 17/01/23.
//

import UIKit

class NewsCard: UITableViewCell {
    
    /*
        From the API We use
     
        1) url for Image
        2) Title
        3) description
        4) Author Name
        5) Published ago
     */
    
    var cardBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
//        view.axis = NSLayoutConstraint.Axis.vertical
        view.backgroundColor = UIColor.secondarySystemBackground
        view.clipsToBounds = true
        view.layer.borderColor = CGColor(gray: 0, alpha: 0.5)
        view.layer.borderWidth = 0.5
        return view
    }()
    
    var newsTitle: UILabel = {
       let title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 15)
        title.numberOfLines = 0
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
    
    var newsDescription: UILabel = {
        let description = UILabel()
        description.adjustsFontSizeToFitWidth = true
        description.translatesAutoresizingMaskIntoConstraints = false
        description.font = UIFont.systemFont(ofSize: 20)
        description.textColor = UIColor.secondaryLabel
        return description
    }()
    
    var newsImage : UIImageView = {
        let newsImage = UIImageView()
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsImage.layer.cornerRadius = 16
        newsImage.clipsToBounds = true
        return newsImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cardBackground)
        addSubview(newsImage)
        addSubview(newsTitle)
//        addSubview(newsDescription)
//        addSubview(authorName)

//        cardBackground.addArrangedSubview(newsImage)
//        cardBackground.addArrangedSubview(newsTitle)
//        cardBackground.addArrangedSubview(newsDescription)
//        cardBackground.addArrangedSubview(authorName)
        
        cardBackgroundConstraints()
        newsImageConstraints()
        newsTitleConstraints()
//        newsDescriptionConstraints()
//        authorNameConstraints()
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
        newsImage.heightAnchor.constraint(equalTo: cardBackground.heightAnchor, multiplier: 0.75).isActive = true
        newsImage.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 16).isActive = true
        newsImage.topAnchor.constraint(equalTo: cardBackground.topAnchor,constant: 16).isActive = true
        newsImage.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor,constant: -16).isActive = true
    }
    
    fileprivate func newsTitleConstraints() {
        newsTitle.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 7).isActive = true
        newsTitle.bottomAnchor.constraint(equalTo: cardBackground.bottomAnchor,constant: -7).isActive  = true
        newsTitle.leadingAnchor.constraint(equalTo: newsImage.leadingAnchor).isActive = true
        newsTitle.trailingAnchor.constraint(equalTo: newsImage.trailingAnchor).isActive = true
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
        
        let url = URL(string: (res?.urlToImage) ?? "")
        
        guard let finalURL = url else {
            return
        }
        downloadImage(from: finalURL)
    }
}
