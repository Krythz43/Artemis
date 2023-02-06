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
        case .business : return "business"
        case .sports : return "sports"
        case .technology : return "technology"
        case .entertainment : return "entertainment"
        case .health : return "health"
        case .science : return "science"
        case .general : return "general"
        case .undefined : return ""
        default: return ""
    }
}
