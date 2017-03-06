//
//  Search.swift
//  SlidePuzzle
//
//  Created by Matthew Ruston on 2/24/17.
//  Copyright © 2017 Matt. All rights reserved.
//

import Foundation

protocol Action {}

//TODO: Make this a protocol that is also equatable?
class Problem: Equatable {
    func isGoalState() -> Bool {
        return false
    }
    
    //Returns action and its cost
    func getLegalActions() -> [Action] {
        return []
    }
    
    func successorStateForAction(action: Action) -> Problem {
        return self
    }
    
    public static func ==(lhs: Problem, rhs: Problem) -> Bool {
        return lhs.equals(rhs)
    }
    
    func equals(_ rhs: Problem) -> Bool {
        return false
    }
    
    func hueristic() -> Double {
        return 0
    }
}


//Takes a problem and returns the actions needed
func AStarSearch(problem: Problem, completion: (([Action])->())? ) {
    DispatchQueue.global(qos: .background).async {
        let queue = PriorityQueue<Problem>()
        queue.push(item: problem, priority: 0)
        
        var count = 0
        
        //List of paths and their costs
        var visitedStates: [Problem] = [problem]
        var paths: [([Action], Double)] = [([], 0)]
        
        while queue.count > 0 {
            let state = queue.pop()!
            let index = visitedStates.index(of: state)!
            count += 1
            
            if state.isGoalState() {
                print("\(count) : \(paths[index].0.count)")
                DispatchQueue.main.async {
                    completion?(paths[index].0)
                }
                return
            }
            
            let actions = state.getLegalActions()
            for action in actions {
                let cost = 1.0
                let nextState = state.successorStateForAction(action: action)
                
                var newPath = paths[index].0
                newPath.append(action)
                let oldCost = paths[index].1
                let newCost = oldCost + cost
                let priority = newCost + nextState.hueristic()
                
                if let nextIndex = visitedStates.index(of: nextState) {
                    let previousCost = paths[nextIndex].1
                    
                    if previousCost > newCost {
                        paths[nextIndex] = (newPath, newCost)
                        queue.update(item: nextState, cost: priority)
                    }
                } else {
                    visitedStates.append(nextState)
                    paths.append((newPath, newCost))
                    queue.push(item: nextState, priority: priority)
                }
            }
        }
        
        DispatchQueue.main.async {
            completion?([])
        }
    }
}
