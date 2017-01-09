//
//  ImageViewGrid.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/2/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit

enum Direction {
    case up
    case down
    case left
    case right
}

class Tile {
    //The actual location the tile should be located
    let x: Int
    let y: Int
    var image: UIImage?
    
    init(x: Int, y: Int, image: UIImage?) {
        self.x = x
        self.y = y
        self.image = image
    }
}

class TileGameBoard: UIView {
    fileprivate let containerView = UIStackView()
    fileprivate let size: Int
    fileprivate var missingTile: Tile?
    
    var imageViews: [[TileView]] = []
    var tiles: [[Tile]] = []
    
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
            for y in 0..<size {
                
                let tileView = TileView()
                tileView.delegate = self
                tileView.image = UIImage(named: "squirrel")
                tileView.x = x
                tileView.y = y
                
                stackView.addArrangedSubview(tileView)
                
                imageViews[x].append(tileView)
            }
        }
    }
    
    func setImage(image: UIImage) {
        guard let originalCGImage = image.cgImage else {
            return
        }
        
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        
        for x in 0..<size {
            tiles.append([])
            for y in 0..<size {
                let frame = CGRect(x: CGFloat(x)/CGFloat(size) * imageSize.width, y: CGFloat(y)/CGFloat(size) * imageSize.height, width: imageSize.width/CGFloat(size), height: imageSize.height/CGFloat(size))
                let newImage = UIImage(cgImage: originalCGImage.cropping(to: frame)!)
                
                tiles[x].append(Tile(x: x, y: y, image: newImage))
                imageViews[x][y].image = newImage
            }
        }
        
        missingTile = tiles[0][0]
    }
    
    func shuffleTiles() {
        var x = 0
        var y = 0
        var previousDirection = Direction.up
        
        for _ in 0...(size * size * 3) {
            var options: [Direction] = []
            
            if x > 0 && previousDirection != .right {
                options.append(.left)
            }
            if x < size - 1 && previousDirection != .left {
                options.append(.right)
            }
            if y > 0 && previousDirection != .down {
                options.append(.up)
            }
            if y < size - 1 && previousDirection != .up {
                options.append(.down)
            }
            
            if options.count == 0 {
                break
            }
            
            let choice = options[Int(arc4random_uniform(UInt32(options.count)))]
            previousDirection = choice
            
            switch choice {
            case .up:
                swapTiles(x: x, y: y, newX: x, newY: y - 1)
                y = y - 1
            case .down:
                swapTiles(x: x, y: y, newX: x, newY: y + 1)
                y = y + 1
            case .left:
                swapTiles(x: x, y: y, newX: x - 1, newY: y)
                x = x - 1
            case .right:
                swapTiles(x: x, y: y, newX: x + 1, newY: y)
                x = x + 1
            }
        }
        
        setTileImages()
    }
    
    func swapTiles(x: Int, y: Int, newX: Int, newY: Int) {
        if x != newX || y != newY {
            let temp = tiles[newX][newY]
            tiles[newX][newY] = tiles[x][y]
            tiles[x][y] = temp
        }
    }
    
    func setTileImages() {
        for x in 0..<size {
            for y in 0..<size {
                if tiles[x][y] === missingTile {
                    imageViews[x][y].image = nil
                } else {
                    imageViews[x][y].image = tiles[x][y].image
                }
            }
        }
    }
    
}



extension TileGameBoard: TileViewDelegate {
    func didTap(tileView: TileView) {
        let x = tileView.x
        let y = tileView.y
        
        //check the surrounding locations
        if x > 0 && tiles[x - 1][y] === missingTile {
            swapTiles(x: x, y: y, newX: x - 1, newY: y)
        } else
        if x < size - 1 && tiles[x + 1][y] === missingTile {
            swapTiles(x: x, y: y, newX: x + 1, newY: y)
        } else
        if y > 0 && tiles[x][y - 1] === missingTile {
            swapTiles(x: x, y: y, newX: x, newY: y - 1)
        } else
        if y < size - 1 && tiles[x][y + 1] === missingTile {
            swapTiles(x: x, y: y, newX: x, newY: y + 1)
        }
        
        setTileImages()
    }
}
