//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by Pawee Kittiwathanakul on 17/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import UIKit
import Kingfisher
class MovieTableViewCell: UITableViewCell {
  
  @IBOutlet weak var movieImage: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var popularityLabel: UILabel!
  
  @IBOutlet weak var backDropImage: UIImageView!
  
  @IBOutlet weak var rattingLabel: UILabel!
  
  var score:Double = 0
  func setCell(movieIndex: results,scoreRatting: Double) {
    self.score = scoreRatting
    titleLabel.text = movieIndex.title
    popularityLabel.text = String(movieIndex.popularity)
    
    if let urlposter = movieIndex.poster_path, let urlbackdrop = movieIndex.backdrop_path {
      let poster = URL(string: "https://image.tmdb.org/t/p/original\( urlposter)")
      let backdrop = URL(string: "https://image.tmdb.org/t/p/original\(urlbackdrop)")
      
      movieImage.kf.setImage(with: poster)
      backDropImage.kf.setImage(with: backdrop)
      
    }
   
    
    if movieIndex.vote_count == 0 {
      if score > 0 {
        let sumratting = (Int(movieIndex.vote_average) * Int(movieIndex.vote_count)) + Int(score * 2)
        let sumratting2 = Int(movieIndex.vote_count + 1)
        let ans = sumratting / sumratting2
        rattingLabel.text = String(ans)
      }else {
      let sumratting = (Int(movieIndex.vote_average) * Int(movieIndex.vote_count))
         rattingLabel.text = String(sumratting)
      }
    }else {
      if score > 0 {
         let sumratting = (Int(movieIndex.vote_average) * Int(movieIndex.vote_count)) + Int(score * 2)
         let sumratting2 = Int(movieIndex.vote_count + 1)

         let ans = sumratting / sumratting2
         rattingLabel.text = String(ans)
      }else {
        let sumratting = (Int(movieIndex.vote_average) * Int(movieIndex.vote_count) ) / Int(movieIndex.vote_count)
        rattingLabel.text = String(sumratting)
      }

    }
    
    
    
    
    
    
    
    
    
    
  }
}
