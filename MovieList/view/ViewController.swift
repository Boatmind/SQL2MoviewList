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
  
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieList()
    }
    
    func getMovieList() {
        let apiManager = APIManager()
        apiManager.getMovie(urlString: "http://api.themoviedb.org/3/discover/movie") { [weak self] (result: Result<movieList?, APIError>) in
            
            switch result {
            case .success(let movie):
                
                if let movie = movie {
                  self?.movies = movie.results
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
        cell.setCell(movieIndex: movieIndex)
        
        return cell
    }
    
    
}
extension ViewController :UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
   
    performSegue(withIdentifier: "viewGoToDetail", sender: movies[indexPath.row].id)
    
  }
}

