//
//  News.swift
//  Artemis
//
//  Created by Krithick Santhosh on 12/01/23.
//

import Foundation

struct Articles : Decodable {
    var source: Source?
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

struct SourcesV2: Decodable {
    var sources: [Source]?
}
