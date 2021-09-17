//
//  Episode.swift
//  GOTApplication
//
//  Created by Axel Imberdis on 17/09/2021.
//

import Foundation

class Episode : Decodable {
    var url: String
    var name: String
    var season: Int
    var number: Int
    var airdate: String
    var runtime: Int
    var summary: String
    var image: GOTImages
}

class GOTImages : Decodable {
    var medium: String
    var original: String
}


class List : Decodable {
    var episodes: [Episode]
}

class Episodes: Decodable {
    var _embedded: List
}
