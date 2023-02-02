//
//  News.swift
//  Artemis
//
//  Created by Krithick Santhosh on 12/01/23.
//

import Foundation

struct Articles : Decodable {
    var source : Source?
    var title : String?
    var author : String?
    var description : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String?
    var content : String?
}

struct News : Decodable {
    var status : String?
    var totalResults : Int?
    var articles : [Articles]?
}

struct Source : Decodable {
    var id : String?
    var name : String?
//    let description: String?
//    let url: String?
//    let category: String?
//    let language: String?
//    let country: String?
}

struct SourcesV2: Decodable {
    let sources: [Source]?
}

// move to news app utils/models
let countryCodeDict: [String:String] = ["United States":"us", "India":"in", "United Arab Emirates":"ae", "Argentina":"ar", "Austria":"at", "Australia":"au", "Belgium":"be", "Bulgaria":"bg", "Brazil":"br", "Canada":"ca", "Switzerland":"ch", "China":"cn", "Colombia":"co", "Cuba":"cu", "Czechia":"cz", "Germany":"de", "Egypt":"eg", "France":"fr", "United Kingdom":"gb", "Greece":"gr", "Hong Kong":"hk", "Hungary":"hu", "Indonesia":"id", "Ireland":"ie", "Israel":"il", "Italy":"it", "Japan":"jp", "Korea":"kr", "Lithuania":"lt", "Latvia":"lv", "Morocco":"ma", "Mexico":"mx", "Malaysia":"my", "Nigeria":"ng", "Netherlands":"nl", "Norway":"no", "New Zealand":"nz", "Philippines":"ph", "Poland":"pl", "Portugal":"pt", "Romania":"ro", "Serbia":"rs", "Russia":"ru", "Saudi Arabia":"sa", "Sweden":"se", "Singapore":"sg", "Slovenia":"si", "Slovakia":"sk", "Thailand":"th", "Turkey":"tr", "Taiwan":"tw", "Ukraine":"ua", "Venezuela":"ve", "South Africa":"za"]


//struct Address: Decodable {
//    var city:String
//}
//
//struct Company:Decodable {
//    var name:String
//                     }
//
//struct News : Decodable {
//    var id : Int
//    var name : String
//    var username : String
//    var website : String
//    var address: Address
//    var company: Company
//}
