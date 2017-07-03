//
//  MovieCell.swift
//  flix
//
//  Created by Skyler Ruesga on 6/21/17.
//  Copyright © 2017 Skyler Ruesga. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            
            
            posterImageView.af_setImage(withURL: movie.posterURL!)
            
            posterImageView.alpha = 0.0
            titleLabel.alpha = 0.0
            overviewLabel.alpha = 0.0
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.posterImageView.alpha = 1.0
                self.titleLabel.alpha = 1.0
                self.overviewLabel.alpha = 1.0
            })

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
