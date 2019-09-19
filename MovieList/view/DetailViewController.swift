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
protocol ScoreRating: class {
  func setScoreRating(score:Double,id:Int)
}
class DetailViewController: UIViewController {
  var indexMovie : Int?
  weak var delegate : ScoreRating?
  var idMovie:Int?
  var detailMovie : DetailMovieList?
  let defaults = UserDefaults.standard
  
  @IBOutlet weak var cosMisView: CosmosView!
  @IBOutlet weak var moviewImageView: UIImageView!
  @IBOutlet weak var titalLabel: UILabel!
  @IBOutlet weak var detailLabel
  : UILabel!
  @IBOutlet weak var catagoryLabel: UILabel!
  @IBOutlet weak var languageLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    guard let indexMovie = indexMovie else {
      return
    }
    checkDefalue(index: indexMovie)
    getDetailMovie(index: indexMovie)
   
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
    delegate?.setScoreRating(score: cosMisView.rating, id: idMovie ?? 0)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
   
  }
  
  
  
  func checkDefalue(index:Int) {
    let scoreRatting = defaults.double(forKey: "\(indexMovie ?? 0)")
    
    cosMisView.rating = scoreRatting
    cosMisView.text = String(scoreRatting)
    
  }
  
  func setUi(data:DetailMovieList) {
    DispatchQueue.main.sync { // Main Threed
      titalLabel.text = data.originalTitle
      detailLabel.text = data.overview
    }
    
    if !(data.genres?.isEmpty ?? false) {
      var valueCatagory = ""
      if let data = data.genres {
        
        
        for (index, value) in (data.enumerated()) {
          if let value = value.name{
             valueCatagory += "\(value) "
          }
        }
      }
      
      DispatchQueue.main.sync { // Main Threed
        catagoryLabel.text = valueCatagory
        
      }
      
    }else {
         DispatchQueue.main.async {
         self.catagoryLabel.text = "-"
      }
    }
    DispatchQueue.main.sync {
      languageLabel.text = data.originalLanguage
    }
    if let urlposter = data.posterPath {
      let poster = URL(string: "https://image.tmdb.org/t/p/original\(urlposter)")
      
      self.moviewImageView.kf.setImage(with: poster)
      
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




