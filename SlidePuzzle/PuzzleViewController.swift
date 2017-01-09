//
//  ViewController.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/2/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit

fileprivate let GridSize = 4

class PuzzleViewController: UIViewController {
    
    fileprivate var imageViews: [[UIImageView]] = []
    let gameBoard = TileGameBoard(size: GridSize)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(gameBoard)
        gameBoard.translatesAutoresizingMaskIntoConstraints = false
        gameBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gameBoard.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gameBoard.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gameBoard.heightAnchor.constraint(equalTo: gameBoard.widthAnchor).isActive = true
        
        if let image = UIImage(named: "squirrel") {
            gameBoard.setImage(image: image)
            gameBoard.shuffleTiles()
        }
    }

}

