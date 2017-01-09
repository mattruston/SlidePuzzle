//
//  AppNavigationController.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/9/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        
        let rootViewController = SelectionViewController()
        rootViewController.delegate = self
        viewControllers = [rootViewController]
    }
}


//MARK: - SelectionViewControllerDelegate

extension AppNavigationController: SelectionViewControllerDelegate {
    func didSelect(image: UIImage?, difficulty: Difficulty) {
        let puzzleViewController = PuzzleViewController()
        puzzleViewController.image = image
        puzzleViewController.gameMode = difficulty
        
        show(puzzleViewController, sender: nil)
    }
}
