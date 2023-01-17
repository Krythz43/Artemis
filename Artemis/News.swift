//
//  News.swift
//  Artemis
//
//  Created by Krithick Santhosh on 12/01/23.
//

import Foundation

struct Articles : Decodable {
    var sources : Source?
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
}


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
