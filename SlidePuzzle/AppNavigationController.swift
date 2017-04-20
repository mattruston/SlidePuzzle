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
        
        let tabBarController = UITabBarController()
        tabBarController.title = "Select Puzzle"
        
        let selectionViewController = SelectionViewController()
        selectionViewController.delegate = self
        selectionViewController.title = "Images"
        
        let photoPickerViewController = PhotoPickerViewController()
        photoPickerViewController.delegate = self
        photoPickerViewController.title = "Photos"
        
        tabBarController.viewControllers = [selectionViewController, photoPickerViewController]
        tabBarController.tabBar.isTranslucent = false

        viewControllers = [tabBarController]
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
