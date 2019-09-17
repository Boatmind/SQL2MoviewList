//
//  movieList.swift
//  assigment
//
//  Created by Pawee Kittiwathanakul on 16/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import Foundation

struct movieList:Codable {
    var page:Int
    var total_pages:Int
    var results: [results]
    // var genre_ids:[String] = []
}

struct results:Codable {
    var popularity:Double
    var id:Int?
    var video:Bool
    var vote_count:Int
    var vote_average:Double
    var title:String
    var release_date:String
    var original_language:String
    var original_title:String
    var backdrop_path:String?
    var poster_path:String?
    private enum CodingKeys: String, CodingKey {
        case popularity
        case id
        case video
        case vote_count
        case vote_average
        case title
        case release_date
        case original_language
        case original_title
        case backdrop_path
        case poster_path
    }
}


