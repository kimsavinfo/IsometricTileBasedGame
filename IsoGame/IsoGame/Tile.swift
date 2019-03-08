//
//  Tile.swift
//  IsoGame
//
//  Created by Kim SAVAROCHE on 08/03/2019.
//  Copyright © 2019 Kim SAVAROCHE. All rights reserved.
//

import Foundation

enum Direction: Int {
    
    case N,NE,E,SE,S,SW,W,NW
    
    var description:String {
        switch self {
        case .N:return "North"
        case .NE:return "North East"
        case .E:return "East"
        case .SE:return "South East"
        case .S:return "South"
        case .SW:return "South West"
        case .W:return "West"
        case .NW:return "North West"
        }
    }
}

enum Tile: Int {
    
    case Ground, Wall, Droid
    
    var description:String {
        switch self {
        case .Ground:return "Ground"
        case .Wall:return "Wall"
        case .Droid:return "Droid"
        }
    }
}

enum Action: Int {
    case Idle, Move
    
    var description:String {
        switch self {
        case .Idle:return "Idle"
        case .Move:return "Move"
        }
    }
}
