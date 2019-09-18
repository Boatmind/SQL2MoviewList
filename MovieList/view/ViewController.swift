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
    var checkFilter:Int = 0
    var checkScoller:Bool = true
    var pageASC:Int = 1
    var pageDESC:Int = 1
    var isclickASC:Bool = false
    var isclickBSCE:Bool = true
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var movieTableView: UITableView!
  
  @IBOutlet weak var loadingView: UIView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
      refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
      movieTableView.addSubview(refreshControl)
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("viewwillAppear : \(scoreRatting)")
    getMovieList()
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    

  }
  
  @objc func refresh(sender:AnyObject) {
    // Code to refresh table view
    if checkFilter == 0 {
       DispatchQueue.main.async {
        self.isclickBSCE = true
        self.getMovieList()
        self.refreshControl.endRefreshing()
      }
    }else{
      DispatchQueue.main.async {
        self.isclickASC = true
        self.getMovieListASC()
        self.refreshControl.endRefreshing()
      }
    }
    
  }
  
  @IBAction func filterItem(_ sender: Any) {
    let alert = UIAlertController(title: "Saved", message: "Selected Frame is Saved", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "DESC", style:.default , handler: { (UIAlertAction) in
      self.isclickBSCE = true
      self.checkFilter = 0
      self.getMovieList()
      alert.editButtonItem.isEnabled = false
      
      
    }))
    alert.addAction(UIAlertAction(title: "ABSC", style:.default , handler: { (UIAlertAction) in
      self.isclickASC = true
      self.checkFilter = 1
      self.getMovieListASC()
      alert.editButtonItem.isEnabled = false
      
      
    }))
    alert.addAction(UIAlertAction(title: "Cancle", style:.default , handler: { (UIAlertAction) in
      
    }))
   
    
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func getMovieListASC() {
    loadingView.isHidden = false
    let apiManager = APIManager()
    print(isclickASC)
    if self.isclickASC {
           pageASC = 1
     }else{
      
     }
    apiManager.getMovieASC(urlString: "http://api.themoviedb.org/3/discover/movie", pageASC: pageASC) { [weak self] (result: Result<movieList?, APIError>) in
      
      switch result {
      case .success(let movie):
        
        if let movie = movie {
          if self?.isclickASC ?? false {
             self?.movies = movie.results
             self?.isclickASC = false
          }else {
             self?.movies.append(contentsOf: movie.results)
          }
          
          self?.scoreRatting = Array(repeating: 0, count: self?.movies.count ?? 0)
          
          for (index, _) in (self?.scoreRatting.enumerated())! {
            self?.scoreRatting[index] = (self?.defaults.double(forKey: "\(index)"))!
            
            print("After index : \(index) and element: \(String(describing: self?.scoreRatting[index]))")
            
          }
          DispatchQueue.main.async {
            self?.pageASC += 1
            self?.loadingView.isHidden = true
            self?.movieTableView.reloadData()
            
          }
          
        }
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  
    func getMovieList() {
         loadingView.isHidden = false
        let apiManager = APIManager()
      if self.isclickBSCE {
              pageDESC = 1
      }else{
        
      }
      apiManager.getMovie(urlString: "http://api.themoviedb.org/3/discover/movie", page: pageDESC) { [weak self] (result: Result<movieList?, APIError>) in
            
            switch result {
            case .success(let movie):
              
                if let movie = movie {
                  
                  if self?.isclickBSCE ?? false {
                    self?.movies = movie.results
                    self?.isclickBSCE = false
                    
                  }else {
                    print("fdsafdsafdsa")
                    self?.movies.append(contentsOf: movie.results)
                  }
                  
                  
                  
                  
                  
                  self?.scoreRatting = Array(repeating: 0, count: self?.movies.count ?? 0)
                  for (index, _) in (self?.scoreRatting.enumerated())! {
                    self?.scoreRatting[index] = (self?.defaults.double(forKey: "\(index)"))!
                    
                    print("After index : \(index) and element: \(String(describing: self?.scoreRatting[index]))")
                    
                  }
                  DispatchQueue.main.async {
                    self?.loadingView.isHidden = true
                    self?.pageDESC += 1
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
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == movies.count - 1 && loadingView.isHidden {
      
      if checkFilter == 0 {
         getMovieList()
      }else{
         getMovieListASC()
      }
      
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

