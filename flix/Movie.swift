//
//  Movie.swift
//  flix
//
//  Created by Skyler Ruesga on 7/3/17.
//  Copyright © 2017 Skyler Ruesga. All rights reserved.
//

import Foundation

class Movie {
    
    
    var title: String
    var overview: String
    var releaseDate: String
    var posterURL: URL?
    var backdropURL: URL?
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? "No title"
        self.overview = dictionary["overview"] as? String ?? "No overview"
        
        self.releaseDate = dictionary["release_date"] as? String ?? "No release date"
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterPathString = dictionary["poster_path"] as! String
        let backdropString = dictionary["backdrop_path"] as! String
        
        
        self.posterURL = URL(string: baseURL + posterPathString)
        self.backdropURL = URL(string: baseURL + backdropString)
        
        
        
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
