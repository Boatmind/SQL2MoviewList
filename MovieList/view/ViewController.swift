//
//  ViewController.swift
//  MovieList
//
//  Created by Pawee Kittiwathanakul on 16/9/2562 BE.
//  Copyright © 2562 Pawee Kittiwathanakul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var movies : [Movie] = []
  var scoreRatting :[Double] = []
  var indexpartMovie : Int = 0
  let defaults = UserDefaults.standard
  var page = 1
  var refreshControl = UIRefreshControl()
  let apiManager = APIManager()
  @IBOutlet weak var movieTableView: UITableView!
  
  @IBOutlet weak var loadingView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getMovieList()
    setRefreshControl()
  }
  
  @objc func refresh(sender:AnyObject) {
    // Code to refresh table view
    self.getMovieList()
    DispatchQueue.main.async {
      self.refreshControl.endRefreshing()
    }
  }
  
  @IBAction func filterItem(_ sender: Any) {
    let alert = UIAlertController(title: "Saved", message: "Selected Frame is Saved", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "DESC", style:.default , handler: { (UIAlertAction) in
      self.getMovieList(filter: .desc)
      alert.editButtonItem.isEnabled = false
      
    }))
    alert.addAction(UIAlertAction(title: "ABSC", style:.default , handler: { (UIAlertAction) in
      self.getMovieList(filter: .asc)
      alert.editButtonItem.isEnabled = false
      
      
    }))
    alert.addAction(UIAlertAction(title: "Cancle", style:.default , handler: { (UIAlertAction) in
      
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  func setRefreshControl() {
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
    movieTableView.addSubview(refreshControl)
  }
  func getMovieList(page: Int = 1, filter: Filter? = nil) {
    loadingView.isHidden = false
    apiManager.getMovie(page: page, filter: filter) { [weak self] (result: Result<MovieList?, APIError>) in
      
      switch result {
      case .success(let movie):
        if let movie = movie {
          
          if page == 1 {
             self?.movies = movie.results
          } else {
             self?.movies.append(contentsOf: movie.results)
          }

          self?.addValueScoreRatting()
          
          DispatchQueue.main.async {
            self?.loadingView.isHidden = true
            self?.page += 1
            self?.movieTableView.reloadData()
          }
          
        }
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func addValueScoreRatting() {
    self.scoreRatting = Array(repeating: 0, count: self.movies.count)
    for (index, _) in (self.scoreRatting.enumerated()) {
      self.scoreRatting[index] = (self.defaults.double(forKey: "\(index)"))
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
    
    let movie = movies[indexPath.row]
    cell.setCell(movie: movie, scoreRatting: scoreRatting[indexPath.row])
    
    return cell
  }
  
  
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == movies.count - 1 && loadingView.isHidden {
      getMovieList(page: page)
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
    self.scoreRatting[id] = score
    print("index :\(id) and element :\(score)")
    defaults.set(score, forKey: "\(id)")
    print("Protocal : \(scoreRatting)")
    
    self.movieTableView.reloadData()
  }
  
  
}

