//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Doğa Bayram on 15.11.2018.
//  Copyright © 2018 Doğa Bayram. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
   var bird = SKSpriteNode()
   var bg = SKSpriteNode()
    
   var scoreLabel = SKLabelNode()
    
    
    enum ColliderType : UInt32 {
        
        case Bird = 1
        case Object = 2
        case Gap = 4
        
        
    }
    
    
    var gameOver = false
    var score = 0
    var gameOverLabel = SKLabelNode()
    
    var timer = Timer()
    
    
    @objc func makePipes(){
        
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100) )
        
        let gapHeight = bird.size.height * 4
        
        let movementAmount = arc4random() % UInt32(self.frame.height) / 2
        
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
      
        var pipeFirst = SKSpriteNode()
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        pipeFirst = SKSpriteNode(texture: pipeTexture)
        
        pipeFirst.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffset)
        
        pipeFirst.run(movePipes)
        
        pipeFirst.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipeFirst.physicsBody?.isDynamic = false
        
        pipeFirst.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipeFirst.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        pipeFirst.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        pipeFirst.zPosition = -1
        
        
        self.addChild(pipeFirst)
        
        var pipeSecond = SKSpriteNode()
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        pipeSecond = SKSpriteNode(texture: pipe2Texture)
        
        pipeSecond.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture.size().height / 2 - gapHeight / 2 + pipeOffset)
        
        pipeSecond.run(movePipes)
        
        pipeSecond.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipeSecond.physicsBody?.isDynamic = false
        
        pipeSecond.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipeSecond.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        pipeSecond.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        pipeSecond.zPosition = -1
        self.addChild(pipeSecond)
        
        let gap = SKNode()
        
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        
        gap.physicsBody?.isDynamic = false
        
        gap.run(movePipes)
        
        gap.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody?.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody?.collisionBitMask = ColliderType.Gap.rawValue
        
        self.addChild(gap)
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if gameOver == false {
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
    
            
            score += 1
            scoreLabel.text = String(score)
            
        } else {
        
        self.speed = 0
        
        gameOver = true
            
            timer.invalidate()
            
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontSize = 30
        
            gameOverLabel.text = "Game Over ! Tap to play again."
            
            
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
        }
        
    }
    }
    
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        
      ownMethod()
        
        
        
   }
    func ownMethod () {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 5)
        
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        
        let makeBGMove = SKAction.repeatForever(SKAction.sequence([moveBGAnimation,shiftBGAnimation]))
        
        var i : CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x:bgTexture.size().width * i, y: self.frame.midY)
            
            bg.size.height = self.frame.height
            
            bg.run(makeBGMove)
            
            bg.zPosition = -2
            
            self.addChild(bg)
            
            i += 1
            
            
        }
        
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture,birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        
        bird.physicsBody?.isDynamic = false
        
        
        bird.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        
        self.addChild(bird)
        
        let ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.maxX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        
        self.addChild(scoreLabel)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
        
       bird.physicsBody?.isDynamic = true
        
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)

        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        
        } else {
            
            gameOver = false
            
            score = 0
            
            self.speed = 1
            
            self.removeAllChildren()
            
            ownMethod()
            
            
        }
       
    }
    

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
