//
//  NewsClassifications.swift
//  Artemis
//
//  Created by Krithick Santhosh on 06/02/23.
//

import Foundation

enum APICalls {
    case everything
    case geoSearch
    case querySearch
    case categoricalSearch
    case sources
    case sourceSearch
}

enum categories{
    case business
    case sports
    case technology
    case entertainment
    case health
    case science
    case general
    case undefined
}


func getCategory(_ category : categories) -> String {
   
    switch category {
        case .business : return "Business"
        case .sports : return "Sports"
        case .technology : return "Technology"
        case .entertainment : return "Entertainment"
        case .health : return "Health"
        case .science : return "Science"
        case .general : return "General"
        case .undefined : return ""
        default: return ""
    }
}
