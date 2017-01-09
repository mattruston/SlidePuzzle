//
//  TileView.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/2/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit

protocol TileViewDelegate: class {
    func didTap(tileView: TileView)
}

class TileView: UIImageView {
    var x: Int = 0
    var y: Int = 0
    weak var delegate: TileViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTap() {
        delegate?.didTap(tileView: self)
    }
}
