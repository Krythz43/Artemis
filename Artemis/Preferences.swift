//
//  Preferences.swift
//  Artemis
//
//  Created by Krithick Santhosh on 03/02/23.
//

import UIKit

class Preferenes: TableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let categoriesList = SourcesList()
        categoriesList.sources = SourcesV2(sources: [Source(name: "business"),Source(name: "health"),Source(name: "Entertainment")])
        view.addSubview(categoriesList.view)
    }
}
