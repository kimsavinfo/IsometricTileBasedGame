//
//  PathFinder.swift
//  IsoGame
//
//  Created by Kim SAVAROCHE on 08/03/2019.
//  Copyright © 2019 Kim SAVAROCHE. All rights reserved.
//

import UIKit
import SpriteKit

// A* Pathfinding
class PathFinder {
    let moveCostHorizontalOrVertical = 10
    let moveCostDiagonal = 14
    
    var iniX:Int
    var iniY:Int
    var finX:Int
    var finY:Int
    var level:[[Int]]
    var openList:[String: PathNode]
    var closedList:[String: PathNode]
    var path = [CGPoint]()
    
    init(xIni:Int, yIni:Int, xFin:Int, yFin:Int, lvlData:[[Int]]) {
        iniX = xIni
        iniY = yIni
        finX = xFin
        finY = yFin
        level = lvlData
        openList = [String: PathNode]()
        closedList = [String: PathNode]()
        path = [CGPoint]()
        
        //invert y coordinates - pre conversion (spriteKit inverted coordinate system).
        //This PathFnding code ONLY works with positive (absolute) values
        
        iniY = -iniY
        finY = -finY
        
        
        let node:PathNode = PathNode(xPos: iniX, yPos: iniY, gVal: 0, hVal: 0, link: nil)
        openList[String(iniX)+" "+String(iniY)] = node;
        
    }
    
    func findPath() -> [CGPoint] {
        searchLevel()
        
        var pathWithYInversionRestored = path.map({i in i * CGPoint(x:1, y:-1)})
        pathWithYInversionRestored.reverse()
        return pathWithYInversionRestored
    }
    
    // TODO: optim with http://www.policyalmanac.org/games/binaryHeaps.htm
    // Example http://www.gotoandplay.it/_articles/2005/04/mazeChaser.php
    func searchLevel() {
        var curNode:PathNode?
        var endNode:PathNode?
        var lowF = 100000
        var finished:Bool = false
        
        for obj in openList {
            let curF = obj.1.g + obj.1.h
            
            if (lowF > curF) {
                lowF = curF
                curNode = obj.1
            }
            
        }
        
        
        if (curNode == nil) {
            // No path
            return
        } else {
            
            let listKey = String(curNode!.x)+" "+String(curNode!.y)
            
            openList[listKey] = nil
            closedList[listKey] = curNode
            
            if ((curNode!.x == finX) && (curNode!.y == finY)) {
                endNode = curNode!
                finished = true
            }
            
            // Check each of the 8 adjacent squares
            for i in -1..<2 {
                for j in -1..<2 {
                    
                    let col = curNode!.x + i;
                    let row = curNode!.y + j;
                    
                    if ((col >= 0 && col < level[0].count)
                        && (row >= 0 && row < level.count)
                        && (i != 0 || j != 0))
                    {
                        
                        let listKey = String(col)+" "+String(row)
                        
                        if ((level[row][col] == Global.tilePath.traversable)
                            && (closedList[listKey] == nil)
                            && (openList[listKey] == nil))
                        {
                            // Prevent cutting corners on diagonal movement
                            var moveIsAllowed = true
                            
                            if ((i != 0) && (j != 0)) {
                                //is diagonal move
                                
                                if ((i == -1) && (j == -1)) {
                                    if (level[row][col+1] != Global.tilePath.traversable
                                        || level[row+1][col] != Global.tilePath.traversable
                                        ) {
                                        moveIsAllowed = false
                                    }
                                    
                                } else if ((i == 1) && (j == -1)) {
                                    if (level[row][col-1] != Global.tilePath.traversable
                                        || level[row+1][col] != Global.tilePath.traversable
                                        ) {
                                        moveIsAllowed = false
                                    }
                                } else if ((i == -1) && (j == 1)) {
                                    if (level[row][col+1] != Global.tilePath.traversable
                                        || level[row-1][col] != Global.tilePath.traversable
                                        ) {
                                        moveIsAllowed = false
                                    }
                                } else if ((i == 1) && (j == 1)) {
                                    if (level[row][col-1] != Global.tilePath.traversable
                                        || level[row-1][col] != Global.tilePath.traversable
                                        ) {
                                        moveIsAllowed = false
                                    }
                                }
                                
                            }
                            
                            if (moveIsAllowed) {
                                var g:Int
                                if ((i != 0) && (j != 0)) {
                                    g = moveCostDiagonal
                                    
                                } else {
                                    g = moveCostHorizontalOrVertical
                                }
                                
                                let h = heuristic(row: row, col: col)
                                openList[listKey] = PathNode(xPos: col, yPos: row, gVal: g, hVal: h, link: curNode)
                            }
                        }
                        
                    }
                }
            }
            
            if (finished == false) {
                searchLevel();
            } else {
                retracePath(node: endNode!)
            }
            
        }
    }
    
    // MARK: - Calculate heuristic
    
    // Diagonal Shortcut method is slightly more expensive but more accurate than Manhattan method
    // Reference: http://www.policyalmanac.org/games/heuristics.htm
    func heuristic(row:Int, col:Int) -> Int {
        let xDistance = abs(col - finX)
        let yDistance = abs(row - finY)
        if (xDistance > yDistance) {
            return moveCostDiagonal*yDistance + moveCostHorizontalOrVertical*(xDistance-yDistance)
        } else {
            return moveCostDiagonal*xDistance + moveCostHorizontalOrVertical*(yDistance-xDistance)
        }
    }
    
    func retracePath(node:PathNode) {
        
        let step = CGPoint(x: node.x, y: node.y)
        path.append(step)
        
        if (node.g > 0) {
            retracePath(node: node.parentNode!);
        }
    }
    
}

class PathNode {
    
    let x:Int
    let y:Int
    let g:Int
    let h:Int
    let parentNode:PathNode?
    
    init(xPos:Int, yPos:Int, gVal:Int, hVal:Int, link:PathNode?) {
        
        self.x = xPos
        self.y = yPos
        self.g = gVal
        self.h = hVal
        
        if (link != nil) {
            self.parentNode = link!;
        } else {
            self.parentNode = nil
        }
    }
}
