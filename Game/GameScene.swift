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
// The category on SpriteKit is just a single 32-bit integer, acting as a bitmask. This is a fancy way of saying each of the 32-bits in the integer represents a single category (and hence you can have 32 categories max). Here you're setting the first bit to indicate a skeleton, the next bit over to represent a princess, and so on.
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
    var passedLevel: Bool = false
    
    // Flags to track whether a button is pressed or held
    var isLeftArrowButtonPressed = false
    var isRightArrowButtonPressed = false
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "dungeonBackground")
//        background.position = CGPoint(x: 70, y: 50)
        background.blendMode = .replace
        background.zPosition = -1
        background.size.width = view.frame.width
        background.size.height = view.frame.height
        addChild(background)
        
        princess = SKSpriteNode(imageNamed: "princess")
        princess.position = CGPoint(x: -280, y: -30)
        princess.zPosition = 1
        
        // Right after the line setting the princess's position, define princess's characteristics
        // 1 Create a physics body for the sprite. In this case, the body is defined as a rectangle of the same size as the sprite, since that's a decent approximation for the princess.
        princess.physicsBody = SKPhysicsBody(rectangleOf: princess.size)
        // 2 Set the sprite to be dynamic. This means that the physics engine will not control the movement of the princess. You will through the code you've already written, using move actions.
        princess.physicsBody?.isDynamic = true
        // 3 Set the category bit mask to be the princessCategory you defined earlier.
        princess.physicsBody?.categoryBitMask = PhysicsCategory.princess
        // 4 contactTestBitMask indicates what categories of objects this object should notify the contact listener when they intersect. You choose skeleton here.
        princess.physicsBody?.contactTestBitMask = PhysicsCategory.skeleton
        // 5 collisionBitMask indicates what categories of objects this object that the physics engine handle contact responses to (i.e. bounce off of). You don't want the skeleton and princess to bounce off each other — it's OK for them to go right through each other in this game — so you set this to .none.
        princess.physicsBody?.collisionBitMask = PhysicsCategory.none
        // 6 This is important to set for fast moving bodies like princesss, because otherwise there is a chance that two fast moving bodies can pass through each other without a collision being detected.
        princess.physicsBody?.usesPreciseCollisionDetection = true

        addChild(princess)
        
        skeleton = SKSpriteNode(imageNamed: "skeleton")
        skeleton.position = CGPoint(x: 280, y: -30)
        skeleton.zPosition = 1
        
        // Collision Detection and Physics: Implementation
        // 1 Create a physics body for the sprite. In this case, the body is defined as a rectangle of the same size as the sprite, since that's a decent approximation for the skeleton.
        skeleton.physicsBody = SKPhysicsBody(rectangleOf: skeleton.size)
        
        // 2 Set the sprite to NOT be dynamic. This means that the physics engine will not control the movement of the skeleton. You will through the code you've already written, using move actions.
        //skeleton.physicsBody?.isDynamic = true
        skeleton.physicsBody?.isDynamic = false
        
        // 3 Set the category bit mask to be the skeletonCategory you defined earlier.
        skeleton.physicsBody?.categoryBitMask = PhysicsCategory.skeleton
        
        // 4 contactTestBitMask indicates what categories of objects this object should notify the contact listener when they intersect. You choose princess here.
        skeleton.physicsBody?.contactTestBitMask = PhysicsCategory.princess
        
        // 5 collisionBitMask indicates what categories of objects this object that the physics engine handle contact responses to (i.e. bounce off of). You don't want the skeleton and princess to bounce off each other — it's OK for them to go right through each other in this game — so you set this to .none.
        // Princess correctly passes in front of skeleton, so that's the intended behaviour.
        skeleton.physicsBody?.collisionBitMask = PhysicsCategory.none

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
        
        // This sets up the physics world to have no gravity, and sets the scene as the delegate to be notified when two physics bodies collide.
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        /* When we're ready for it, this is how we play background music.
        // This uses SKAudioNode to play and loop the background music for your game.
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
         */
        
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
    
    // Method that will be called when the princess collides with the skeleton
    func princessDidCollideWithSkeleton(princess: SKSpriteNode, skeleton: SKSpriteNode) {
        // Saeed: This is when we display the skeleton's dialog. Call your dialog box code here.
        print("Skeleton's dialog goes here.")
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
   
    // 2 Here is the check to see if the two bodies that collided are the princess and skeleton, and if so, the method you wrote earlier is called.
    if ((firstBody.categoryBitMask & PhysicsCategory.skeleton != 0) &&
        (secondBody.categoryBitMask & PhysicsCategory.princess != 0)) {
        if let skeleton = firstBody.node as? SKSpriteNode,
        let princess = secondBody.node as? SKSpriteNode {
          princessDidCollideWithSkeleton(princess: princess, skeleton: skeleton)
      }
    }
  }


}

