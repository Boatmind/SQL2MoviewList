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
    func getMovie(urlString: String, completion: @escaping (Result<movieList?, APIError>) -> Void) {
        guard var url = URLComponents(string: urlString) else {
            return
        }
        url.queryItems = [
            URLQueryItem(name: "api_key", value: "328c283cd27bd1877d9080ccb1604c91"),
            URLQueryItem(name: "primary_release_date.lte", value: "2016-12-31"),
            URLQueryItem(name: "sort_by", value: "release_date.desc"),
            URLQueryItem(name: "page", value: "1")
        ]
//        print(url2)
    
        var request = URLRequest(url: url.url!)

        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let _ = error {
                completion(.failure(.invalidData))
            } else if let data = data, let response = response as? HTTPURLResponse {
                
                if response.statusCode == 200 {
                    
                    do {
                        let values = try JSONDecoder().decode(movieList.self, from: data)
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
