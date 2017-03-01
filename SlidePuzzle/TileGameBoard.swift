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
    let game: SlidePuzzleGame
    fileprivate let containerView = UIStackView()
    var imageViews: [[TileView]] = []
    var images: [[UIImage]] = []
    
    fileprivate var solving = false
    fileprivate var remainingActions: [SlidePuzzleAction] = []
    
    fileprivate var size: Int {
        return game.size
    }
    
    init(size: Int = 0) {
        self.game = SlidePuzzleGame(size)
        game.shuffleTiles()
        
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
                let tile = TileView()
                tile.x = x
                tile.y = y
                tile.delegate = self
                stackView.addArrangedSubview(tile)
                imageViews[x].append(tile)
            }
        }
    }
    
    func setImage(image: UIImage) {
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
    
    func setTileImages() {
        for x in 0..<size {
            for y in 0..<size {
                if (x, y) == self.game.missingTile {
                    imageViews[x][y].image = nil
                } else {
                    let tiles = self.game.boardState
                    if let tile = tiles[x][y] {
                        imageViews[x][y].image = images[tile.row][tile.column]
                    }
                }
            }
        }
    }
    
    func solve() {
        if solving {
            return
        }
        
        solving = true
        guard let actions = AStarSearch(problem: game) as? [SlidePuzzleAction] else {
            return
        }
        
        remainingActions = actions
        takeNextAction()
    }
    
    func takeNextAction() {
        solving = true
        
        guard let action = remainingActions.first else {
            solving = false
            return
        }
        
        remainingActions.removeFirst()
        
        game.takeAction(action: action)
        setTileImages()
        
        if remainingActions.count > 0 {
            let deadlineTime = DispatchTime.now() + 0.25
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.takeNextAction()
            }
        } else {
            solving = false
        }
        
    }
    
}



extension TileGameBoard: TileViewDelegate {
    func didTap(tileView: TileView) {
        if solving {
            return
        }
        
        let x = tileView.x
        let y = tileView.y
        
        //check the surrounding locations
        if (x - 1, y) == game.missingTile {
            game.takeAction(action: .right)
        } else
        if (x + 1, y) == game.missingTile {
            game.takeAction(action: .left)
        } else
        if (x, y - 1) == game.missingTile {
            game.takeAction(action: .down)
        } else
        if (x, y + 1) == game.missingTile {
            game.takeAction(action: .up)
        }
        
        setTileImages()
    }
}
