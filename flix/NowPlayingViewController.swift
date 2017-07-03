//
//  NowPlayingViewController.swift
//  flix
//
//  Created by Skyler Ruesga on 6/21/17.
//  Copyright © 2017 Skyler Ruesga. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD


class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [Movie] = []
    var originalMovies: [Movie] = []
    var refreshControl: UIRefreshControl!
    var alertController: UIAlertController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.flash(.progress, delay: 1.0)

        self.activityIndicator.startAnimating()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        setupAlertController()
        fetchMovies()
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // This method updates movies based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, movies is the same as the original data(originalMovies)
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        movies = searchText.isEmpty ? originalMovies : originalMovies.filter { (movie: Movie) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return movie.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.movies = self.originalMovies
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    
    // asynchronous function
    func fetchMovies() {
        
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.originalMovies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            } else if let error = error {
                self.present(self.alertController, animated: true)
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
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
}
