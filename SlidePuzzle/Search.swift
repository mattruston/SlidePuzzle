//
//  Search.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 2/24/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import Foundation

protocol Action {}
protocol GameState: Hashable { }
protocol Problem {
    associatedtype S: GameState
    associatedtype A: Action
    
    func isGoal(_ state: S) -> Bool
    func getLegalActions(_ state: S) -> [A]
    func stateSuccessor(_ state: S, for action: A) -> S
    func hueristic(_ state: S) -> Double
}

/// Takes a problem and initial state and returns the actions needed to reach a goal state
func AStarSearch<P: Problem>(problem: P, initialState: P.S, completion: (([P.A])->())? ) {
    DispatchQueue.global(qos: .background).async {
        let queue = PriorityQueue<P.S>()
        queue.push(item: initialState, priority: 0)
        
        var visitedStates: Set<P.S> = [initialState]
        var paths: [P.S : ([P.A], Double)] = [initialState : ([], 0)]
        
        while queue.count > 0 {
            let state = queue.pop()!
            let path = paths[state]!
            
            if problem.isGoal(state) {
                DispatchQueue.main.async {
                    completion?(path.0)
                }
                return
            }
            
            let actions = problem.getLegalActions(state)
            for action in actions {
                let cost = 1.0
                let nextState = problem.stateSuccessor(state, for: action)
                
                var newPath = path.0
                newPath.append(action)
                let oldCost = path.1
                let newCost = oldCost + cost
                let priority = newCost + problem.hueristic(nextState)
                
                if visitedStates.contains(nextState) {
                    let previousCost = paths[nextState]!.1
                    
                    if previousCost > newCost {
                        paths[nextState] = (newPath, newCost)
                        queue.update(item: nextState, cost: priority)
                    }
                } else {
                    visitedStates.insert(nextState)
                    paths[nextState] = (newPath, newCost)
                    queue.push(item: nextState, priority: priority)
                }
            }
        }
        
        DispatchQueue.main.async {
            completion?([])
        }
    }
}
