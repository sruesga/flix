//
//  DetailViewController.swift
//  flix
//
//  Created by Skyler Ruesga on 6/22/17.
//  Copyright © 2017 Skyler Ruesga. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterBackdrop: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie["title"] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            let baseURL = "https://image.tmdb.org/t/p/w500"
            posterBackdrop.af_setImage(withURL: URL(string:baseURL + (movie["backdrop_path"] as! String))!)
            posterImageView.af_setImage(withURL: URL(string:baseURL + (movie["poster_path"] as! String))!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
