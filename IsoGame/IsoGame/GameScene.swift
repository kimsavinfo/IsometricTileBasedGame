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
    let layerIsoGround:SKNode
    let layerIsoObjects:SKNode
    
    var tiles:[[(Int, Int)]]
    let tileSize = (width:53, height:53)
    let hero = Droid()
    let nthFrame = 6
    var nthFrameCount = 0
    
    override init(size: CGSize) {
        tiles =     [[(1,7), (1,0), (1,0), (1,0), (1,0), (1,0), (1,1)]]
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (0,0), (1,2)])
        tiles.append([(1,6), (0,0), (2,2), (0,0), (0,0), (0,0), (1,2)])
        tiles.append([(1,6), (0,0), (0,0), (1,5), (1,4), (1,4), (1,3)])
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (0,0), (0,0)])
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (0,0), (0,0)])
        tiles.append([(1,5), (1,4), (1,4), (1,4), (1,4), (1,4), (1,3)])
        
        view2D = SKSpriteNode()
        viewIso = SKSpriteNode()
        layerIsoGround = SKNode()
        layerIsoObjects = SKNode()
        
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
        
        viewIso.addChild(layerIsoGround)
        viewIso.addChild(layerIsoObjects)
        
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
        if (tile == Tile.Ground) {
            layerIsoGround.addChild(tileSprite)
        } else if (tile == Tile.Wall || tile == Tile.Droid) {
            layerIsoObjects.addChild(tileSprite)
        }
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
        
        nthFrameCount += 1
        if (nthFrameCount == nthFrame) {
            nthFrameCount = 0
            updateOnNthFrame()
        }
    }
    
    func updateOnNthFrame() {
        sortDepth()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: viewIso)
        var touchPos2D = pointIsoTo2D(p: touchLocation!)
        touchPos2D = touchPos2D + CGPoint(x:tileSize.width/2, y:-tileSize.height/2)
        let heroPos2D = touchPos2D + CGPoint(x:-tileSize.width/2, y:-tileSize.height/2)
        
        let deltaY = heroPos2D.y - hero.tileSprite2D.position.y
        let deltaX = heroPos2D.x - hero.tileSprite2D.position.x
        let degrees = atan2(deltaX, deltaY) * (180.0 / CGFloat(Double.pi))
        hero.facing = degreesToDirection(degrees: degrees)
        hero.update()
        
        let velocity = 100
        let time = TimeInterval(distance(p1:heroPos2D, p2:hero.tileSprite2D.position)/CGFloat(velocity))
        hero.tileSprite2D.removeAllActions()
        hero.tileSprite2D.run(SKAction.move(to: heroPos2D, duration: time))
    }
    
    // MARK: Coordinate conversion
    
    func sortDepth() {
        let childrenSortedForDepth = layerIsoObjects.children.sorted() {
            
            let p0 = self.pointIsoTo2D(p: $0.position)
            let p1 = self.pointIsoTo2D(p: $1.position)
            
            if ((p0.x+(-p0.y)) > (p1.x+(-p1.y))) {
                return false
            } else {
                return true
            }
            
        }
        
        for i in 0..<childrenSortedForDepth.count {
            let node = (childrenSortedForDepth[i] )
            node.zPosition = CGFloat(i)
            
        }
    }
    
    func degreesToDirection(degrees:CGFloat) -> Direction {
        var angle = degrees
        if (angle < 0) {
            angle += 360
        }
        
        let directionRange = 45.0
        angle += CGFloat(directionRange/2)
        
        var direction = Int(floor(Double(angle)/directionRange))
        if (direction == 8) {
            direction = 0
        }
        
        return Direction(rawValue: direction)!
    }
    
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
