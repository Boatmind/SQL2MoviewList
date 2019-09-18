//
//  ViewController.swift
//  MovieList
//
//  Created by Pawee Kittiwathanakul on 16/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var movies : [results] = []
    var scoreRatting :[Double] = []
    var indexpartMovie : Int = 0
    let defaults = UserDefaults.standard
  
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieList()
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("viewwillAppear : \(scoreRatting)")
    getMovieList()
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    

  }
    
    func getMovieList() {
        let apiManager = APIManager()
        apiManager.getMovie(urlString: "http://api.themoviedb.org/3/discover/movie") { [weak self] (result: Result<movieList?, APIError>) in
            
            switch result {
            case .success(let movie):
                
                if let movie = movie {
                  self?.movies = movie.results
                  
                  self?.scoreRatting = Array(repeating: 0, count: self?.movies.count ?? 0)
                  for (index, _) in (self?.scoreRatting.enumerated())! {
                    self?.scoreRatting[index] = (self?.defaults.double(forKey: "\(index)"))!
                    
                    print("After index : \(index) and element: \(String(describing: self?.scoreRatting[index]))")
                    
                  }
                  DispatchQueue.main.async {
                    self?.movieTableView.reloadData()
                  }
                  
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "viewGoToDetail" {
      if let viewController = segue.destination as? DetailViewController,
        let sender = sender as? Int {
        viewController.indexMovie = sender
        viewController.delegate = self
        viewController.idMovie = indexpartMovie
      }
      
    }
  }
}

extension ViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
      
        let movieIndex = movies[indexPath.row]
        cell.setCell(movieIndex: movieIndex, scoreRatting: scoreRatting[indexPath.row])
        
        return cell
    }
    
    
}
extension ViewController :UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.indexpartMovie = indexPath.row
    performSegue(withIdentifier: "viewGoToDetail", sender: movies[indexPath.row].id)
    
  }
}

extension ViewController : ScoreRating {
  func setScoreRating(score: Double,id: Int) {
    print(score)
    self.scoreRatting[id] = score
      print("index :\(id) and element :\(score)")
      defaults.set(score, forKey: "\(id)")
      print("Protocal : \(scoreRatting)")
    
      self.movieTableView.reloadData()
  }
  
  
}

