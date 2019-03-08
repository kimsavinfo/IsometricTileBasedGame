//
//  Character.swift
//  IsoGame
//
//  Created by Kim SAVAROCHE on 08/03/2019.
//  Copyright © 2019 Kim SAVAROCHE. All rights reserved.
//

import UIKit
import SpriteKit

protocol TileObject {
    var tile:Tile {get}
}

class Character {
    
    var facing:Direction
    var action:Action
    
    var tileSprite2D:SKSpriteNode!
    var tileSpriteIso:SKSpriteNode!
    
    init() {
        facing = Direction.E
        action = Action.Idle
    }
    
}

class Droid:Character, TileObject {
    let tile = Tile.Droid
    
    func update() {
        if (self.tileSpriteIso != nil) {
            self.tileSpriteIso.texture = TextureDroid.sharedInstance.texturesIso[self.action.rawValue]![self.facing.rawValue]
            
        }
        if (self.tileSprite2D != nil) {
            self.tileSprite2D.texture = TextureDroid.sharedInstance.textures2D[self.action.rawValue]![self.facing.rawValue]
        }
    }
}
