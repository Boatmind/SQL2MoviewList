//
//  DetailMovieList.swift
//  MovieList
//
//  Created by Pawee Kittiwathanakul on 17/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import Foundation

struct DetailMovieList :Codable{
  var originalTitle:String?
  var overview:String?
  var genres:[genresDetail]?
  var posterPath:String?
  var originalLanguage: String?
  var voteAverage:Double?
  var voteCount:Double?
  
  private enum CodingKeys: String, CodingKey {
    case originalTitle = "original_title"
    case overview
    case genres
    case posterPath = "poster_path"
    case originalLanguage = "original_language"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    
  }
}
struct genresDetail:Codable {
  var name:String?
}
