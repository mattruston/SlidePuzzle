//
//  PhotoPickerCell.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/9/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit
import Photos

class PhotoImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var requestID: PHImageRequestID?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
