//
//  PosterCell.swift
//  flix
//
//  Created by Skyler Ruesga on 6/23/17.
//  Copyright © 2017 Skyler Ruesga. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!

    var movie: Movie! {
        didSet {
            posterImageView.af_setImage(withURL: movie.posterURL!)
            posterImageView.alpha = 0.0
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.posterImageView.alpha = 1.0
            })

        }
    }
    
    
}
