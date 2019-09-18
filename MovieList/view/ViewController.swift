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
    let defaultsValue = UserDefaults.standard
    var page = 1
    var checkStatus: Bool = false
  var checkloadMore: Bool = false
    @IBOutlet weak var movieTableView: UITableView!
  
  @IBOutlet weak var loadingView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
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
      loadingView.isHidden = false
        let apiManager = APIManager()
      apiManager.getMovie(urlString: "http://api.themoviedb.org/3/discover/movie", page: page) { [weak self] (result: Result<movieList?, APIError>) in
            
            switch result {
            case .success(let movie):
                
                if let movie = movie {
                  self?.movies.append(contentsOf: movie.results)
                  
                  self?.scoreRatting = Array(repeating: 0, count: self?.movies.count ?? 0)
                  
//                  for (index, element) in (self?.scoreRatting.enumerated())! {
//
//                    self?.scoreRatting[index] = (self?.defaults.double(forKey: "\(index)"))!
//
//                    print("After index : \(index) and element: \(String(describing: self?.scoreRatting[index]))")
//
//                  }
                  for (index, element) in (self?.movies.enumerated())! {
                    
                    self?.scoreRatting[index] = (self?.defaults.double(forKey: "\(element.id)"))!
                    
                    print("After index : \(index) and element: \(String(describing: self?.scoreRatting[index]))")
                    
                  }
                  if self?.checkStatus ?? false{
                    self?.checkStatus = false
                  }else {
                     self?.page += 1
                  }
                  DispatchQueue.main.sync {
                    self?.loadingView.isHidden = true
                   
                    self?.movieTableView.reloadData()
                  }
                  
                }
                
            case .failure(let error):
              print(error.localizedDescription)
              let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
              let action = UIAlertAction(title: "OK", style: .destructive)
              alert.addAction(action)
              DispatchQueue.main.sync {
                self?.loadingView.isHidden = true
                self?.present(alert, animated: true)
              }
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
  
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == movies.count - 1  && loadingView.isHidden {
        getMovieList()
    }
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if indexPath.row == movies.count  && loadingView.isHidden {
     
    }
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
    for (index, element) in movies.enumerated() {
      if movies[index].id == id {
         self.scoreRatting[index] = score
         defaults.set(score, forKey: "\(id)")
        
      }
      
    }
      print("Protocal : \(scoreRatting)")
      checkStatus = true
      self.movieTableView.reloadData()
  }
  
  
}

