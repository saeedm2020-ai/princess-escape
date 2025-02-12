//
//  GameScene.swift
//  Game
//
//  Created by Saeed Mohamed on 2/3/25.
//

import SpriteKit
import GameplayKit

// Collision Detection and Physics
// This code sets up the constants for the physics categories you'll need
// The category on SpriteKit is just a single 32-bit integer, acting as a bitmask. This is a fancy way of saying each of the 32-bits in the integer represents a single category (and hence you can have 32 categories max). Here you're setting the first bit to indicate a monster, the next bit over to represent a projectile, and so on.
struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let skeleton   : UInt32 = 0b1       // 1
  static let princess   : UInt32 = 0b10      // 2
}


class GameScene: SKScene {
    
    // Declare the sprites for the princess, left and right arrows
    var princess: SKSpriteNode!
    var skeleton: SKSpriteNode!
    var leftArrowButton: SKSpriteNode!
    var rightArrowButton: SKSpriteNode!
    
    // Flags to track whether a button is pressed or held
    var isLeftArrowButtonPressed = false
    var isRightArrowButtonPressed = false
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "dungeonBackground")
//        background.position = CGPoint(x: 70, y: 50)
        background.blendMode = .replace
        background.zPosition = -1
        background.size.width = view.frame.width / 1.15
        background.size.height = view.frame.height
        addChild(background)
        
        princess = SKSpriteNode(imageNamed: "princess")
        princess.position = CGPoint(x: -280, y: -30)
        princess.zPosition = 1
        addChild(princess)
        
        skeleton = SKSpriteNode(imageNamed: "skeleton")
        skeleton.position = CGPoint(x: 280, y: -30)
        skeleton.zPosition = 1
        addChild(skeleton)

        
        let Wisp = SKSpriteNode(imageNamed: "Wisp")
        Wisp.position = CGPoint(x: 0, y: 0)
        addChild(Wisp)
        
        let hearts = SKSpriteNode(imageNamed: "hearts")
        hearts.position = CGPoint(x: -280, y: 130)
        addChild(hearts)
        
        leftArrowButton = SKSpriteNode(imageNamed: "leftarrowbutton")
        leftArrowButton.position = CGPoint(x: -320, y: -130)
        leftArrowButton.zPosition = 2
        self.addChild(leftArrowButton)
        
        rightArrowButton = SKSpriteNode(imageNamed: "rightarrowbutton")
        rightArrowButton.position = CGPoint(x: 350, y: -130)
        rightArrowButton.zPosition = 2
        self.addChild(rightArrowButton)
        
        /*
        let dialoguebox = SKSpriteNode(imageNamed: "dialoguebox.png")
        dialoguebox.position = CGPoint(x: -140, y: -170)
        dialoguebox.zPosition = 3
        addChild(dialoguebox)
         */
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            isLeftArrowButtonPressed = false
            isRightArrowButtonPressed = false
            
            handleTouches(touches, isTouching: true)
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            handleTouches(touches, isTouching: false)
        }
        
        func handleTouches(_ touches: Set<UITouch>, isTouching: Bool) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                
                if leftArrowButton.contains(touchLocation) {
                    isLeftArrowButtonPressed = isTouching
                }
                
                else if rightArrowButton.contains(touchLocation) {
                    isRightArrowButtonPressed = isTouching
                }
            }
        }
        
        override func update(_ currentTime: TimeInterval) {
            if isLeftArrowButtonPressed {
                movePrincessLeft()
            }
            
            if isRightArrowButtonPressed {
                movePrincessRight()
            }
        }
        
        func movePrincessLeft() {
            if princess.position.x - princess.size.width / 2 > -size.width / 2 {
                princess.position.x -= 2.5 // Move the princess left
            }
        }
        
        func movePrincessRight() {
            if princess.position.x + princess.size.width / 2 < size.width / 2 {
                princess.position.x += 2.5 // Move the princess right
            }
        }
    
    
}

// create an extension at the end of GameScene.swift implementing the SKPhysicsContactDelegate protocol
extension GameScene: SKPhysicsContactDelegate {
  
  // contact delegate method
  // Since you set the scene as the physics world's contactDelegate earlier, this method will be called whenever two physics bodies collide and their contactTestBitMasks are set appropriately.
  func didBegin(_ contact: SKPhysicsContact) {
    // 1 This method passes you the two bodies that collide, but does not guarantee that they are passed in any particular order. So this bit of code just arranges them so they are sorted by their category bit masks so you can make some assumptions later.
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
   
    // 2 Here is the check to see if the two bodies that collided are the projectile and monster, and if so, the method you wrote earlier is called.
    if ((firstBody.categoryBitMask & PhysicsCategory.skeleton != 0) &&
        (secondBody.categoryBitMask & PhysicsCategory.princess != 0)) {
        if let skeleton = firstBody.node as? SKSpriteNode,
        let princess = secondBody.node as? SKSpriteNode {
          projectileDidCollideWithMonster(projectile: projectile, skeleton: skeleton)
      }
    }
  }


}

