//
//  ViewController.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/2/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit

fileprivate let GridSize = 3

class PuzzleViewController: UIViewController {
    
    fileprivate var imageViews: [[UIImageView]] = []
    let gameBoard = TileGameBoard(size: GridSize)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(gameBoard)
        gameBoard.translatesAutoresizingMaskIntoConstraints = false
        gameBoard.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gameBoard.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gameBoard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameBoard.widthAnchor.constraint(equalTo: gameBoard.heightAnchor).isActive = true
        
        if let image = UIImage(named: "squirrel") {
            gameBoard.setImage(image: image)
            gameBoard.shuffleTiles()
        }
    }

}

