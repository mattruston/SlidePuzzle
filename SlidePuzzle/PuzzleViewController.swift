//
//  ViewController.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/2/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit

enum Difficulty: Int {
    case easy = 3
    case normal = 4
    case difficult = 5
}

class PuzzleViewController: UIViewController {
    
    fileprivate var imageViews: [[UIImageView]] = []
    var gameBoard: TileGameBoard!
    var image: UIImage?
    var gameMode = Difficulty.normal

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameBoard = TileGameBoard(size: gameMode.rawValue)
        
        if let image = image {
            view.backgroundColor = UIColor.black
            
            view.addSubview(gameBoard)
            gameBoard.translatesAutoresizingMaskIntoConstraints = false
            gameBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            gameBoard.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            gameBoard.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            gameBoard.heightAnchor.constraint(equalTo: gameBoard.widthAnchor).isActive = true
            
            gameBoard.setImage(image: image)
            
            let button = UIButton()
            button.setTitle("Solve", for: .normal)
            button.addTarget(self, action: #selector(solve), for: .touchUpInside)
            
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    func solve() {
        gameBoard.solve()
    }

}

