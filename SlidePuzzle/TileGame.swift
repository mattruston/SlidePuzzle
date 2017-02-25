//
//  TileGame.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 2/24/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import Foundation

enum SlidePuzzleAction {
    case left
    case right
    case up
    case down
}

struct GameTile {
    var row: Int
    var column: Int
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}

class SlidePuzzleGame {
    var boardState = [[GameTile?]]()
    //Current Location of missing tile
    var missingTile: (Int, Int) = (0 , 0)
    let size: Int
    
    init(_ size: Int) {
        self.size = size
        
        for x in 0..<size {
            boardState.append([])
            for y in 0..<size {
                boardState[x].append(GameTile(row: x, column: y))
            }
        }
    }
    
    init(_ game: SlidePuzzleGame) {
        self.boardState = game.boardState
        self.missingTile = game.missingTile
        self.size = game.size
    }
    
    func copy() -> SlidePuzzleGame {
        return SlidePuzzleGame(self)
    }
    
    func getLegalActions() -> [SlidePuzzleAction] {
        guard boardState.count > 0 else {
            return []
        }
        
        var actions: [SlidePuzzleAction] = []
        
        if missingTile.0 > 0 {
            actions.append(.up)
        }
        
        if missingTile.0 < boardState.count - 1 {
            actions.append(.down)
        }
        
        if missingTile.1 > 0 {
            actions.append(.left)
        }
        
        if missingTile.1 < boardState[0].count - 1 {
            actions.append(.right)
        }
        
        return actions
    }
    
    func successorStateForAction(action: SlidePuzzleAction) -> SlidePuzzleGame {
        let successor = self.copy()
        successor.takeAction(action: action)
        return successor
    }
    
    func takeAction(action: SlidePuzzleAction) {
        guard getLegalActions().contains(action) else {
            return
        }
        
        switch action {
        case .up:
            swap(first: missingTile, second: (missingTile.0 - 1, missingTile.1))
            missingTile.0 -= 1
        case .down:
            swap(first: missingTile, second: (missingTile.0 + 1, missingTile.1))
            missingTile.0 += 1
        case .left:
            swap(first: missingTile, second: (missingTile.0, missingTile.1 - 1))
            missingTile.1 -= 1
        case .right:
            swap(first: missingTile, second: (missingTile.0, missingTile.1 + 1))
            missingTile.1 += 1
        }
    }
    
    fileprivate func swap(first: (Int, Int), second: (Int, Int)) {
        let firstTile = boardState[first.0][first.1]
        boardState[first.0][first.1] = boardState[second.0][second.1]
        boardState[second.0][second.1] = firstTile
    }
    
    func shuffleTiles() {
        var previousAction = SlidePuzzleAction.up
        
        for _ in 0...(size * size * 3) {
            var options = getLegalActions().filter({ (action) -> Bool in
                return action != previousAction
            })
            
            let action = options[Int(arc4random_uniform(UInt32(options.count)))]
            takeAction(action: action)
            previousAction = action
        }
    }
    
    func isGoalState() -> Bool {
        for row in 0..<size {
            for column in 0..<size {
                if let tile = boardState[row][column] {
                    if tile.column != column || tile.row != row {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}
