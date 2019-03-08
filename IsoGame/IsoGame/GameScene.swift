//
//  GameScene.swift
//  IsoGame
//
//  Created by Kim SAVAROCHE on 02/03/2019.
//  Copyright © 2019 Kim SAVAROCHE. All rights reserved.
//

import SpriteKit
import GameplayKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

class GameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let view2D:SKSpriteNode
    let viewIso:SKSpriteNode
    
    let tiles = [
        [8, 1, 1, 1, 1, 2],
        [7 ,0, 0, 0, 0, 3],
        [7 ,0, 11, 0, 0, 3],
        [7 ,0, 0, 0, 0, 3],
        [7 ,0, 0, 0, 0, 3],
        [6, 5, 5, 5, 5, 4]
    ]
    let tileSize = (width:53, height:53)
    
    override init(size: CGSize) {
        
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
    
    func placeTile2D(image:String, withPosition:CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: image)
        tileSprite.position = withPosition
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        view2D.addChild(tileSprite)
    }
    
    func placeAllTiles2D() {
        for i in 0..<tiles.count {
            let row = tiles[i];
            
            for j in 0..<row.count {
                let tileInt = row[j]
                let tile = Tile(rawValue: tileInt)!
                let point = CGPoint(x: (j*tileSize.width), y: -(i*tileSize.height))
                
                if (tile == Tile.Droid_e) {
                    placeTile2D(image: Tile.Ground.image, withPosition:point)
                }
                
                placeTile2D(image: tile.image, withPosition:point)
            }
            
        }
        
    }
    
    func placeTileIso(image:String, withPosition:CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: image)
        tileSprite.position = withPosition
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        viewIso.addChild(tileSprite)
    }
    
    func placeAllTilesIso() {
        for i in 0..<tiles.count {
            let row = tiles[i];
            
            for j in 0..<row.count {
                let tileInt = row[j]
                let tile = Tile(rawValue: tileInt)!
                let point = point2DToIso(p: CGPoint(x: (j*tileSize.width), y: -(i*tileSize.height)))
                
                if (tile == Tile.Droid_e) {
                    placeTileIso(image: ("futuristic_"+Tile.Ground.image), withPosition:point)
                }
                
                placeTileIso(image: ("futuristic_"+tile.image), withPosition:point)
            }
        }
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
