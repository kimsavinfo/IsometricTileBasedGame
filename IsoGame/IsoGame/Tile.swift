//
//  Tile.swift
//  IsoGame
//
//  Created by Kim SAVAROCHE on 08/03/2019.
//  Copyright © 2019 Kim SAVAROCHE. All rights reserved.
//

import Foundation

enum Tile: Int {
    
    case Ground //0
    case Wall_n //1
    case Wall_ne //2
    case Wall_e //3
    case Wall_se //4
    case Wall_s //5
    case Wall_sw //6
    case Wall_w //7
    case Wall_nw //8
    case Droid_n
    case Droid_ne
    case Droid_e
    case Droid_se
    case Droid_s
    case Droid_sw
    case Droid_w
    case Droid_nw
    
    var description:String {
        switch self {
        case .Ground:
            return "Ground"
        case .Wall_n:
            return "Wall North"
        case .Wall_ne:
            return "Wall North East"
        case .Wall_e:
            return "Wall East"
        case .Wall_se:
            return "Wall South East"
        case .Wall_s:
            return "Wall South"
        case .Wall_sw:
            return "Wall South West"
        case .Wall_w:
            return "Wall West"
        case .Wall_nw:
            return "Wall North West"
        case .Droid_n:
            return "Droid North"
        case .Droid_ne:
            return "Droid North East"
        case .Droid_e:
            return "Droid East"
        case .Droid_se:
            return "Droid South East"
        case .Droid_s:
            return "Droid South"
        case .Droid_sw:
            return "Droid South West"
        case .Droid_w:
            return "Droid West"
        case .Droid_nw:
            return "Droid North West"
        }
    }
    
    
    var image:String {
        switch self {
        case .Ground:
            return "ground"
        case .Wall_n:
            return "wall_n"
        case .Wall_ne:
            return "wall_ne"
        case .Wall_e:
            return "wall_e"
        case .Wall_se:
            return "wall_se"
        case .Wall_s:
            return "wall_s"
        case .Wall_sw:
            return "wall_sw"
        case .Wall_w:
            return "wall_w"
        case .Wall_nw:
            return "wall_nw"
        case .Droid_n:
            return "droid_n"
        case .Droid_ne:
            return "droid_ne"
        case .Droid_e:
            return "droid_e"
        case .Droid_se:
            return "droid_se"
        case .Droid_s:
            return "droid_s"
        case .Droid_sw:
            return "droid_sw"
        case .Droid_w:
            return "droid_w"
        case .Droid_nw:
            return "droid_nw"
        }
    }
}
