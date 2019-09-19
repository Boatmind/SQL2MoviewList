//
//  movieList.swift
//  assigment
//
//  Created by Pawee Kittiwathanakul on 16/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import Foundation

struct MovieList:Codable {
    var page:Int
    var totalPages:Int
    var results: [Movie]
    // var genre_ids:[String] = []
  private enum CodingKeys: String, CodingKey {
    case page
    case totalPages = "total_pages"
    case results
  }
}

struct Movie: Codable {
    var popularity:Double
    var id:Int?
    var video:Bool
    var voteCount:Int
    var voteAverage:Double
    var title:String
    var releaseDate:String
    var originalLanguage:String
    var originalTitle:String
    var backdropPath:String?
    var posterPath:String?
    private enum CodingKeys: String, CodingKey {
        case popularity
        case id
        case video
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case title
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}

enum Filter: String {
  case asc
  case desc
}

enum Status {
  case on
  case off
}


