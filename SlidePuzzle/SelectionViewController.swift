//
//  SelectionViewController.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 1/9/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import UIKit

protocol SelectionViewControllerDelegate: class {
    func didSelect(image: UIImage?, difficulty: Difficulty)
}

class SelectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    
    fileprivate var cellSize: CGSize {
        let size = ((self.collectionView.frame.width - 10) / 3)
        return CGSize(width: size, height: size)
    }
    
    fileprivate var imagePaths = ["squirrel", "squirrel2"]
    
    weak var delegate: SelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Puzzle"
        
        collectionView.register(UINib(nibName: "PhotoImageCell", bundle: nil), forCellWithReuseIdentifier: "PhotoImageCell")
    }
}


//MARK: - UICollectionViewDataSource

extension SelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoImageCell", for: indexPath) as? PhotoImageCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = UIImage(named: imagePaths[indexPath.item])
        
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension SelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}


//MARK: - UICollectionViewDelegate

extension SelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var difficulty = Difficulty.normal
        
        switch difficultySegmentedControl.selectedSegmentIndex {
        case 0:
            difficulty = .easy
        case 1:
            difficulty = .normal
        case 2:
            difficulty = .difficult
        default:
            break
        }
        
        delegate?.didSelect(image: UIImage(named: imagePaths[indexPath.item]), difficulty: difficulty)
    }
}
