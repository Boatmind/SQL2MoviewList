//
//  DetailViewController.swift
//  MovieList
//
//  Created by Pawee Kittiwathanakul on 17/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
class DetailViewController: UIViewController {
  var indexMovie : Int?
  @IBOutlet weak var cosMisView: CosmosView!
  @IBOutlet weak var moviewImage: UIImageView!
  
  @IBOutlet weak var tital: UILabel!
  
  @IBOutlet weak var detail: UILabel!
  
  @IBOutlet weak var genres: UILabel!
  
  @IBOutlet weak var language: UILabel!
  
  var detailMovie : DetailMovieList?
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let indexMovie = indexMovie else {
      return
    }
    getDetailMovie(index: indexMovie)
    //    cosMisView.text = String(Int(detailMovie.vote_average) * Int(detailMovie.vote_count))
    cosMisView.didTouchCosmos = { ratting in
      self.cosMisView.text = String(ratting)
    }
    
    
  }
  
  func setUi(data:DetailMovieList) {
    
    tital.text = data.original_title
    detail.text = data.overview
    if let urlposter = data.poster_path {
      let poster = URL(string: "https://image.tmdb.org/t/p/original\(urlposter)")
      
      self.moviewImage.kf.setImage(with: poster)
    }
  }
  
  func getDetailMovie(index :Int) {
    let apiManager = APIManager()
    apiManager.getDetailMovie(urlString: "https://api.themoviedb.org/3/movie/\(index)?api_key=328c283cd27bd1877d9080ccb1604c91") { [weak self] (result: Result<DetailMovieList?, APIError>) in
      
      switch result {
      case .success(let movie):
        
        if let movie = movie {
          
          self?.setUi(data: movie)
          
        }
      case .failure(_):
        print("error")
      }
    }
    
    
  
    
  }
}
