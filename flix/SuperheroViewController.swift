//
//  SuperheroViewController.swift
//  flix
//
//  Created by Skyler Ruesga on 6/23/17.
//  Copyright © 2017 Skyler Ruesga. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [Movie] = []
    var originalMovies: [Movie] = []
    var refreshControl: UIRefreshControl!
    var alertController: UIAlertController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SuperheroViewController.didPullToRefresh(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        collectionView.dataSource = self
        searchBar.delegate = self
        
        
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing  = 1
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 4
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        
        layout.itemSize = CGSize(width: width, height: width * 3/2)
        
        setupAlertController()
        fetchMovies()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
        cell.movie = movies[indexPath.item]

        return cell
    }
    
    
    
    
    
    
    // asynchronous function
    func fetchMovies() {
        
        
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.originalMovies = movies
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
            } else if let error = error {
                self.present(self.alertController, animated: true)
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    // This method updates movies based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, movies is the same as the original data(originalMovies)
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        self.movies = searchText.isEmpty ? self.originalMovies : self.originalMovies.filter { (movie: Movie) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return movie.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        self.collectionView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.movies = self.originalMovies
        self.collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]
        let vc = segue.destination as! DetailViewController
        vc.movie = movie
    }
    
    
    func setupAlertController() {
        self.alertController = UIAlertController(title: "Not Connected to WiFi", message: "Connect to WiFi to view movies.", preferredStyle: .alert)
        // create a try again action
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel) { (action) in
            self.fetchMovies()
        }
        // add the try again action to the alertController
        alertController.addAction(tryAgainAction)
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
