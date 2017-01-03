//
//  ImageViewGrid.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/2/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit

class Tile {
    let location: CGPoint
    let image: UIImage?
    
    init(location: CGPoint, image: UIImage?) {
        self.location = location
        self.image = image
    }
}

class TileGameBoard: UIView {
    fileprivate let containerView = UIStackView()
    fileprivate let size: Int
    var imageViews: [[UIImageView]] = []
    var tiles: [Tile] = []
    
    init(size: Int = 0) {
        self.size = size
        
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        
        containerView.alignment = .fill
        containerView.distribution = .fillEqually
        containerView.axis = .horizontal
        
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        for x in 0..<size {
            let stackView = UIStackView()
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.axis = .vertical
            
            containerView.addArrangedSubview(stackView)
            imageViews.append([])
            for _ in 0..<size {
                
                let imageView = UIImageView()
                imageView.image = UIImage(named: "squirrel")
                stackView.addArrangedSubview(imageView)
                
                imageViews[x].append(imageView)
            }
        }
    }
    
    func setImage(image: UIImage) {
        guard let originalCGImage = image.cgImage else {
            return
        }
        
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        
        for x in 0..<size {
            for y in 0..<size {
                let frame = CGRect(x: CGFloat(x)/CGFloat(size) * imageSize.width, y: CGFloat(y)/CGFloat(size) * imageSize.height, width: imageSize.width/CGFloat(size), height: imageSize.height/CGFloat(size))
                let newImage = UIImage(cgImage: originalCGImage.cropping(to: frame)!)
                
                tiles.append(Tile(location: CGPoint(x: x, y: y), image: newImage))
                imageViews[x][y].image = newImage
            }
        }
    }
    
    func shuffleTiles() {
        for first in stride(from: tiles.count - 1, to: 0, by: -1) {
            let second = Int(arc4random_uniform(UInt32(first + 1)))

            let temp = tiles[first]
            tiles[first] = tiles[second]
            tiles[second] = temp
        }
        
        setTileImages()
    }
    
    func setTileImages() {
        for t in 0..<tiles.count {
            let y = t % size
            let x = t / size
            
            imageViews[x][y].image = tiles[t].image
        }
    }
}
