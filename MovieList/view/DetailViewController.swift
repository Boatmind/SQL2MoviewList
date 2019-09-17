//
//  DetailViewController.swift
//  MovieList
//
//  Created by Pawee Kittiwathanakul on 17/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import UIKit
import Cosmos
class DetailViewController: UIViewController {
  var detailMovie : results?
  @IBOutlet weak var cosMisView: CosmosView!
  
  @IBOutlet weak var moviewImage: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cosMisView.didTouchCosmos = { ratting in
      print(ratting)
    }
    
    func setting(movie: results) {
      if let urlposter = movie.poster_path {
        let poster = URL(string: "https://image.tmdb.org/t/p/original\(urlposter)")
        moviewImage.kf.setImage(with: poster)
      }
    }
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
