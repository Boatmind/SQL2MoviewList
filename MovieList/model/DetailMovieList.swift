//
//  DetailMovieList.swift
//  MovieList
//
//  Created by Pawee Kittiwathanakul on 17/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import Foundation

struct DetailMovieList :Codable{
  var original_title:String?
  var overview:String?
  var genres:[genresDetail]?
  var poster_path:String?
  var original_language: String?
  var vote_average:Double?
  var vote_count:Double?
}
struct genresDetail:Codable {
  var name:String?
}
