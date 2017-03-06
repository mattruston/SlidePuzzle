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
    
    @IBOutlet fileprivate weak var gameBoard: TileGameBoard!
    @IBOutlet fileprivate weak var loadingView: UIView!
    @IBOutlet fileprivate weak var loadingIndicator: UIActivityIndicatorView!
    
    var image: UIImage?
    var gameMode = Difficulty.normal
    
    fileprivate var solving = false
    fileprivate var remainingActions: [SlidePuzzleAction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = image {
            gameBoard.setUpGameWithSize(size: gameMode.rawValue, image: image)
        }
    }
    
    fileprivate func setLoading(loading: Bool) {
        self.loadingView.isHidden = !loading
        
        UIView.animate(withDuration: 0.2) {
            self.loadingView.alpha = loading ? 0.6 : 0
            
            if loading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction fileprivate func shuffle() {
        gameBoard.shuffle()
    }
    
    
    // MARK: - Solving methods
    
    @IBAction fileprivate func solve() {
        if solving { return }
        solving = true
        setLoading(loading: true)
        
        AStarSearch(problem: gameBoard.game) { actions in
            self.setLoading(loading: false)
            
            guard let actions = actions as? [SlidePuzzleAction] else {
                return
            }
            
            self.remainingActions = actions
            self.takeNextAction()
            
        }

    }
    
    fileprivate func takeNextAction() {
        guard let action = remainingActions.first else {
            solving = false
            return
        }
        
        remainingActions.removeFirst()
        gameBoard.takeAction(action: action)
        
        if remainingActions.count > 0 {
            let deadlineTime = DispatchTime.now() + 0.2
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.takeNextAction()
            }
        } else {
            solving = false
        }
    }

}

