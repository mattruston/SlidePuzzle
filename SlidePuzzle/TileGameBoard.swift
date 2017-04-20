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

class TileGameBoard: UIView {
    var game: SlidePuzzleGame!
    
    fileprivate let containerView = UIStackView()
    var imageViews: [[TileView]] = []
    var images: [[UIImage]] = []
    var loadingView: UIView = UIView()
    
    fileprivate var solving = false
    fileprivate var remainingActions: [SlidePuzzleAction] = []
    
    fileprivate var size: Int {
        return game.size
    }
    
    func setUpGameWithSize(size: Int, image: UIImage) {
        game = SlidePuzzleGame(size)
        
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
                let tile = TileView()
                tile.x = x
                tile.y = y
                tile.delegate = self
                stackView.addArrangedSubview(tile)
                imageViews[x].append(tile)
            }
        }
        
        game.shuffleTiles()
        setImage(image: image)
    }
    
    func shuffle() {
        if (!solving) {
            game.shuffleTiles()
            setTileImages()
        }
    }
    
    func takeAction(action: SlidePuzzleAction) {
        game.takeAction(action: action)
        setTileImages()
    }
    
    fileprivate func setImage(image: UIImage) {
        guard let originalCGImage = image.cgImage else {
            return
        }
        
        let imageSize = CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
        
        let cropSize = (image.size.width < image.size.height ? image.size.width : image.size.height) * image.scale
        let cropFrame = CGRect(x: (imageSize.width - cropSize) / 2, y: (imageSize.height - cropSize) / 2, width: cropSize, height: cropSize)
        
        if let croppedCGImage = originalCGImage.cropping(to: cropFrame) {
            for x in 0..<size {
                images.append([])
                for y in 0..<size {
                    let frame = CGRect(x: CGFloat(x)/CGFloat(size) * cropSize, y: CGFloat(y)/CGFloat(size) * cropSize, width: cropSize/CGFloat(size), height: cropSize/CGFloat(size))
                    let newImage = UIImage(cgImage: croppedCGImage.cropping(to: frame)!)
                    
                    images[x].append(newImage)
                }
            }
        }
        
        setTileImages()
    }
    
    fileprivate func setTileImages() {
        let state = game.currentState
        
        for x in 0..<size {
            for y in 0..<size {
                if (x, y) == state.missingTile {
                    imageViews[x][y].image = nil
                } else {
                    let tiles = state.board
                    if let tile = tiles[x][y] {
                        imageViews[x][y].image = images[tile.row][tile.column]
                    }
                }
            }
        }
    }
}


//Mark: - TileView Delegate Methods

extension TileGameBoard: TileViewDelegate {
    func didTap(tileView: TileView) {
        if solving {
            return
        }
        
        let state = game.currentState
        let x = tileView.x
        let y = tileView.y
        
        //check the surrounding locations
        if (x - 1, y) == state.missingTile {
            game.takeAction(action: .right)
        } else
        if (x + 1, y) == state.missingTile {
            game.takeAction(action: .left)
        } else
        if (x, y - 1) == state.missingTile {
            game.takeAction(action: .down)
        } else
        if (x, y + 1) == state.missingTile {
            game.takeAction(action: .up)
        }
        
        setTileImages()
    }
}
