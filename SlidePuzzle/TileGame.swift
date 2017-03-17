//
//  TileGame.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 2/24/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import Foundation

enum SlidePuzzleAction: Action {
    case left
    case right
    case up
    case down
}

struct GameTile: Equatable {
    var row: Int
    var column: Int
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}

func ==(lhs: GameTile, rhs: GameTile) -> Bool {
    return lhs.column == rhs.column && rhs.row == lhs.row
}

typealias Board = [[GameTile?]]
struct SlidePuzzleGameState: GameState {
    var board = Board()
    //Current Location of missing tile
    var missingTile: (Int, Int) = (0 , 0)
    let size: Int
    
    init(size: Int) {
        self.size = size
        
        for x in 0..<size {
            board.append([])
            for y in 0..<size {
                board[x].append(GameTile(row: x, column: y))
            }
        }
    }
    
    init(board: Board, missingTile: (Int, Int), size: Int) {
        self.board = board
        self.missingTile = missingTile
        self.size = size
    }
    
    //TODO: Improve hash function
    var hashValue: Int {
        var cost = 0
        for row in 0..<size {
            for column in 0..<size {
                if let tile = board[row][column] {
                    let value1 = (abs(tile.column - column) + 1) * (tile.row + 1) * 10000
                    let value2 = (abs(tile.row - row) + 1) * (tile.row + 1) * (tile.row + 1)
                    cost ^= value1 + value2
                }
            }
        }
        
        return cost
    }
    
    static func ==(lhs: SlidePuzzleGameState, rhs: SlidePuzzleGameState) -> Bool {
        guard lhs.size == rhs.size else {
            return false
        }
        
        if lhs.missingTile != rhs.missingTile {
            return false
        }
        
        for x in 0..<lhs.size {
            let answer = lhs.board[x].elementsEqual(rhs.board[x], by: { (lhs, rhs) -> Bool in
                return lhs == rhs
            })
            
            if answer == false {
                return false
            }
        }
        
        return true
    }
}

class SlidePuzzleGame: Problem {
    
    typealias S = SlidePuzzleGameState
    typealias A = SlidePuzzleAction
    
    var currentState: SlidePuzzleGameState
    
    var size: Int {
        return currentState.size
    }
    
    init(_ size: Int) {
        currentState = SlidePuzzleGameState(size: size)
    }
    
    
    //MARK: - Problem Protocol Methods
    
    func getLegalActions(_ state: SlidePuzzleGameState) -> [SlidePuzzleAction] {
        guard state.board.count > 0 else {
            return []
        }
        
        var actions: [SlidePuzzleAction] = []
        
        if state.missingTile.1 > 0 {
            actions.append(.up)
        }
        
        if state.missingTile.1 < state.board[0].count - 1 {
            actions.append(.down)
        }
        
        if state.missingTile.0 > 0 {
            actions.append(.left)
        }
        
        if state.missingTile.0 < state.board.count - 1 {
            actions.append(.right)
        }
        
        return actions
    }
    
    func stateSuccessor(_ state: SlidePuzzleGameState, for action: SlidePuzzleAction) -> SlidePuzzleGameState {
        var newState = state
        
        takeActionOn(&newState, action: action)
        
        return newState
    }
    
    func isGoal(_ state: SlidePuzzleGameState) -> Bool {
        for row in 0..<state.size {
            for column in 0..<state.size {
                if let tile = state.board[row][column] {
                    if tile.column != column || tile.row != row {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func hueristic(_ state: SlidePuzzleGameState) -> Double {
        var cost = 0.0
        for row in 0..<state.size {
            for column in 0..<state.size {
                if let tile = state.board[row][column] {
                    cost += Double(abs(tile.column - column) + abs(tile.row - row))
                }
            }
        }
        
        return cost
    }
    
    
    //MARK: - Helper Methods
    
    fileprivate func takeActionOn(_ state: inout SlidePuzzleGameState, action: SlidePuzzleAction) {
        let actions = getLegalActions(state)
        guard actions.contains(action) else {
            return
        }
        
        var missingTile = state.missingTile
        
        switch action {
        case .up:
            swap(state: &state, first: missingTile, second: (missingTile.0, missingTile.1 - 1))
            missingTile.1 -= 1
        case .down:
            swap(state: &state, first: missingTile, second: (missingTile.0, missingTile.1 + 1))
            missingTile.1 += 1
        case .left:
            swap(state: &state, first: missingTile, second: (missingTile.0 - 1, missingTile.1))
            missingTile.0 -= 1
        case .right:
            swap(state: &state, first: missingTile, second: (missingTile.0 + 1, missingTile.1))
            missingTile.0 += 1
        }
        
        state.missingTile = missingTile
    }
    
    fileprivate func swap(state: inout SlidePuzzleGameState, first: (Int, Int), second: (Int, Int)) {
        let firstTile = state.board[first.0][first.1]
        state.board[first.0][first.1] = state.board[second.0][second.1]
        state.board[second.0][second.1] = firstTile
    }
    
    
    //MARK: - Current Game Methods
    
    func takeAction(action: SlidePuzzleAction) {
        takeActionOn(&currentState, action: action)
    }
    
    func shuffleTiles() {
        var previousAction = SlidePuzzleAction.up
        
        for _ in 0...(currentState.size * currentState.size * 3) {
            var options = getLegalActions(currentState).filter({ (action) -> Bool in
                let upDown = (action == .up && previousAction == .down) || (action == .down && previousAction == .up)
                let leftRight = (action == .left && previousAction == .right) || (action == .right && previousAction == .left)
                return !(upDown || leftRight)
            })
            
            let action = options[Int(arc4random_uniform(UInt32(options.count)))]
            takeActionOn(&currentState, action: action)
            previousAction = action
        }
    }
}
