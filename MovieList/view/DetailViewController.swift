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
protocol ScoreRating {
  func setScoreRating(score:Double,id:Int)
}
class DetailViewController: UIViewController {
  var indexMovie : Int?
  var delegate : ScoreRating?
  var idMovie:Int?
  @IBOutlet weak var cosMisView: CosmosView!
  @IBOutlet weak var moviewImage: UIImageView!
  
  @IBOutlet weak var tital: UILabel!
  
  @IBOutlet weak var detail: UILabel!
  
  @IBOutlet weak var genres: UILabel!
  
  @IBOutlet weak var language: UILabel!
  
  @IBAction func ButtonTapped(_ sender: Any) {
//  self.defaults.set(4.0, forKey: "\(String(describing: indexMovie))")
  }
  var detailMovie : DetailMovieList?
  let defaults = UserDefaults.standard
  override func viewDidLoad() {
    super.viewDidLoad()
   
    guard let indexMovie = indexMovie else {
      return
    }
    checkDefalue(index: indexMovie)
    getDetailMovie(index: indexMovie)
    //    cosMisView.text = String(Int(detailMovie.vote_average) * Int(detailMovie.vote_count))
    cosMisView.didTouchCosmos = { ratting in
      DispatchQueue.main.async {
        self.cosMisView.text = String(ratting)
        self.storeRating(rating: ratting)
      }
    }
  }
  
  func storeRating(rating: Double){
    self.defaults.set(rating, forKey: "\(indexMovie ?? 0)")
    print(defaults.double(forKey: "\(indexMovie ?? 0)"))
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
//    defaults.set(cosMisView.rating, forKey: "\(String(describing: indexMovie))")
    print("DetailRating is :\(cosMisView.rating)")
    delegate?.setScoreRating(score: cosMisView.rating, id: indexMovie ?? 0)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
   
  }
  
  
  
  func checkDefalue(index:Int) {
    let scoreRatting = defaults.double(forKey: "\(indexMovie ?? 0)")
    
    cosMisView.rating = scoreRatting
    
  }
  
  func setUi(data:DetailMovieList) {
    DispatchQueue.main.sync { // Main Threed
      tital.text = data.original_title
      detail.text = data.overview
    }
    
    if !(data.genres?.isEmpty ?? false) {
      DispatchQueue.main.sync { // Main Threed
        genres.text = data.genres?[0].name
      }
      
    }else {
      
    }
    DispatchQueue.main.sync {
      language.text = data.original_language
    }
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


//  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//      (viewController as? ViewController)?.scoreRatting = cosMisView.rating
//
//  }




