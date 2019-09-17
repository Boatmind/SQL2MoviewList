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
                    self?.movieTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
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

