//
//  ApiManager.swift
//  assigment
//
//  Created by Pawee Kittiwathanakul on 16/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidJSON
    case invalidData
}
class APIManager {
  var filter: Filter = .desc
  func getMovie(page: Int, filter: Filter?, completion: @escaping (Result<MovieList?, APIError>) -> Void) {
    if let filter = filter {
      self.filter = filter
    }
        guard var url = URLComponents(string: "http://api.themoviedb.org/3/discover/movie") else {
            return
        }
        url.queryItems = [
            URLQueryItem(name: "api_key", value: "328c283cd27bd1877d9080ccb1604c91"),
            URLQueryItem(name: "primary_release_date.lte", value: "2016-12-31"),
            URLQueryItem(name: "sort_by", value: "release_date.\(self.filter.rawValue)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

    
        var request = URLRequest(url: url.url!)

        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let _ = error {
                completion(.failure(.invalidData))
            } else if let data = data, let response = response as? HTTPURLResponse {
                
                if response.statusCode == 200 {
                    
                    do {
                        let values = try JSONDecoder().decode(MovieList.self, from: data)
                        completion(.success(values))
                    } catch  {
                        completion(.failure(.invalidJSON))
                        
                    }
                }
            }
        }
        task.resume()
    }
  
  func getDetailMovie(urlString: String, completion: @escaping (Result<DetailMovieList?, APIError>) -> Void) {
    guard var url = URLComponents(string: urlString) else {
      return
    }
    url.queryItems = [
      URLQueryItem(name: "api_key", value: "328c283cd27bd1877d9080ccb1604c91")
    ]
    
    var request = URLRequest(url: url.url!)
    
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      if let _ = error {
        completion(.failure(.invalidData))
      } else if let data = data, let response = response as? HTTPURLResponse {
        
        if response.statusCode == 200 {
          
          do {
            let values = try JSONDecoder().decode(DetailMovieList.self, from: data)
            
            completion(.success(values))
            
          } catch  {
            completion(.failure(.invalidJSON))
            
          }
        }
      }
    }
    task.resume()
    
  }
}
