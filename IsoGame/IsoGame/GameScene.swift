//
//  GameScene.swift
//  IsoGame
//
//  Created by Kim SAVAROCHE on 02/03/2019.
//  Copyright © 2019 Kim SAVAROCHE. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let view2D:SKSpriteNode
    let viewIso:SKSpriteNode
    
    var tiles:[[(Int, Int)]]
    let tileSize = (width:53, height:53)
    let hero = Droid()
    
    override init(size: CGSize) {
        tiles =     [[(1,7), (1,0), (1,0), (1,0), (1,0), (1,1)]]
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (1,2)])
        tiles.append([(1,6), (0,0), (2,2), (0,0), (0,0), (1,2)])
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (1,2)])
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (1,2)])
        tiles.append([(1,5), (1,4), (1,4), (1,4), (1,4), (1,3)])
        
        view2D = SKSpriteNode()
        viewIso = SKSpriteNode()
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
    }
    
    override func didMove(to view: SKView) {
        let sizeFactor = tileSize.width * 20
        let deviceScale = self.size.width/CGFloat(sizeFactor)
        
        view2D.position = CGPoint(x:-self.size.width*0.45, y:self.size.height*0.17)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        
        viewIso.position = CGPoint(x:self.size.width*0.12, y:self.size.height*0.12)
        viewIso.xScale = deviceScale
        viewIso.yScale = deviceScale
        addChild(viewIso)
        
        placeAllTiles2D()
        placeAllTilesIso()
    }
    
    func placeTile2D(tile:Tile, direction:Direction, position:CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: textureImage(tile: tile, direction: direction, action: Action.Idle))
        if (tile == hero.tile) {
            hero.tileSprite2D = tileSprite
            hero.tileSprite2D.zPosition = 1
        }
        
        tileSprite.position = position
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        view2D.addChild(tileSprite)
    }
    
    func placeAllTiles2D() {
        for i in 0..<tiles.count {
            let row = tiles[i];
            
            for j in 0..<row.count {
                let tile = Tile(rawValue: row[j].0)!
                let direction = Direction(rawValue: row[j].1)!
                let point = CGPoint(x: (j*tileSize.width), y: -(i*tileSize.height))
                
                if (tile == Tile.Droid) {
                    placeTile2D(tile:Tile.Ground, direction:direction, position:point)
                }
                
                placeTile2D(tile:tile, direction:direction, position:point)
            }
            
        }
        
    }
    
    func placeTileIso(tile:Tile, direction:Direction, position:CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: "futuristic_"+textureImage(tile: tile, direction: direction, action: Action.Idle))
        if (tile == hero.tile) {
            hero.tileSpriteIso = tileSprite
        }
        
        tileSprite.position = position
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        viewIso.addChild(tileSprite)
    }
    
    func placeAllTilesIso() {
        for i in 0..<tiles.count {
            let row = tiles[i];
            
            for j in 0..<row.count {
                let tile = Tile(rawValue: row[j].0)!
                let direction = Direction(rawValue: row[j].1)!
                let point = point2DToIso(p: CGPoint(x: (j*tileSize.width), y: -(i*tileSize.height)))
                
                if (tile == Tile.Droid) {
                    placeTileIso(tile: Tile.Ground, direction:direction, position:point)
                }
                
                placeTileIso(tile: tile, direction:direction, position:point)
            }
        }
    }
    
    // MARK: Update and touch functions
    
    override func update(_ currentTime: CFTimeInterval) {
        hero.tileSpriteIso.position = point2DToIso(p: hero.tileSprite2D.position)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: viewIso)
        var touchPos2D = pointIsoTo2D(p: touchLocation!)
        touchPos2D = touchPos2D + CGPoint(x:tileSize.width/2, y:-tileSize.height/2)
        let heroPos2D = touchPos2D + CGPoint(x:-tileSize.width/2, y:-tileSize.height/2)
        hero.tileSprite2D.position = heroPos2D
    }
    
    // MARK: Coordinate conversion
    
    func point2DToIso(p:CGPoint) -> CGPoint {
        //invert y pre conversion
        var point = p * CGPoint(x:1, y:-1)
        
        //convert using algorithm
        point = CGPoint(x:(point.x - point.y), y: ((point.x + point.y) / 2))
        
        //invert y post conversion
        point = point * CGPoint(x:1, y:-1)
        
        return point
    }
    
    func pointIsoTo2D(p:CGPoint) -> CGPoint {
        //invert y pre conversion
        var point = p * CGPoint(x:1, y:-1)
        
        //convert using algorithm
        point = CGPoint(x:((2 * point.y + point.x) / 2), y: ((2 * point.y - point.x) / 2))
        
        //invert y post conversion
        point = point * CGPoint(x:1, y:-1)
        
        return point
    }
}
