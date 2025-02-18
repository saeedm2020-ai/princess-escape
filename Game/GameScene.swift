//
//  GameScene.swift
//  Game
//
//  Created by Shakira Al-Jahmee
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var background: SKSpriteNode!
    var princess: SKSpriteNode!
    var wisp: SKSpriteNode!
    var hearts: SKSpriteNode!
    var leftArrowButton: SKSpriteNode!
    var rightArrowButton: SKSpriteNode!
    var dialogueBox: SKSpriteNode!
    var dialogueBox2: SKSpriteNode!
    //var continueButton: SKSpriteNode!

    var isLeftArrowButtonPressed = false
    var isRightArrowButtonPressed = false
    
    let skeletonPosition = CGPoint(x: 100, y: -50)
    let proximityThreshold: CGFloat = 50
    
    var idleFrames: [SKTexture] = []
    var walkFrames: [SKTexture] = []
    
    
    
    override func didMove(to view: SKView) {
        
//        background = SKSpriteNode(imageNamed: "background")
//        background.texture?.filteringMode = .nearest // prevents blurring
//        background.blendMode = .replace
//        background.zPosition = -1
//       // background.setScale(5.5) // Adjust based on testing
//
//        background.size = CGSize(width: view.frame.width, height: view.frame.height)
//
////        background.size.width = view.frame.width / 1.16
////        background.size.height = view.frame.height
//        addChild(background)
        
        background = SKSpriteNode(imageNamed: "background")
           background.texture?.filteringMode = .nearest //CRISPY bc spritekit automatically smooths backgrounds
           background.blendMode = .replace
           background.zPosition = -1
           
           // Get the screen width & height in points
           let screenWidth = view.frame.width
           let screenHeight = view.frame.height
           
           // Calculate scale factors for pixel-perfect display
           let scaleX = screenWidth / 426
           let scaleY = screenHeight / 197
           
           // Apply a smaller scale factor to make the background less zoomed in
           let scaleFactor = min(scaleX, scaleY) * 0.85 // Reduce scale factor to 85%

           background.setScale(scaleFactor)
           
           // Center the background
           background.position = CGPoint(x: 0, y: 0)
           background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Ensures centering
           
           addChild(background)
        
        princess = SKSpriteNode(imageNamed: "idle")
        princess.position = CGPoint(x: -320, y: -30)
        princess.zPosition = 1
        
        princess.xScale = 1.75
        princess.yScale = 1.75
        addChild(princess)
       
        // 🎀 Add Princess
//                princess = SKSpriteNode(imageNamed: "idle")
//                princess.position = CGPoint(x: 0, y: 0) // Adjusted position to be on screen
//                princess.zPosition = 1
//                addChild(princess)
                
                // 🏃‍♀️ Load Princess Animations
                idleFrames = [SKTexture(imageNamed: "idle")]
                
                walkFrames = [
                    SKTexture(imageNamed: "phase_1"),
                    SKTexture(imageNamed: "phase_2"),
                    SKTexture(imageNamed: "phase_3"),
                    SKTexture(imageNamed: "phase_4"),
                    SKTexture(imageNamed: "phase_5"),
                    SKTexture(imageNamed: "phase_6")
                ]
        wisp = SKSpriteNode(imageNamed: "wisp.png")
        wisp.position = CGPoint(x: 0, y: 0)
        addChild(wisp)
        
        hearts = SKSpriteNode(imageNamed: "hearts.png")
        
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
        
        dialogueBox = SKSpriteNode(imageNamed: "dialoguebox.png")
        dialogueBox.position = CGPoint(x: -150, y: -130)
        dialogueBox.zPosition = 3
        dialogueBox.alpha = 1
        addChild(dialogueBox)
        
        dialogueBox2 = SKSpriteNode(imageNamed: "dialoguebox2.png")
        dialogueBox2.position = CGPoint(x: 180, y: -130)
        dialogueBox2.zPosition = 3
        dialogueBox2.alpha = 0
        addChild(dialogueBox2)
        

        
        hideDialogueBox()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isLeftArrowButtonPressed = false
        isRightArrowButtonPressed = false
        
        handleTouches(touches, isTouching: true)
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            if leftArrowButton.contains(touchLocation) {
                movePrincessLeft()
            } else if rightArrowButton.contains(touchLocation) {
                movePrincessRight()
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, isTouching: false)
        princess.removeAction(forKey: "walking")
           princess.texture = SKTexture(imageNamed: "idle")
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
        
        let distanceToSkeleton = sqrt(pow(princess.position.x - skeletonPosition.x, 2) +
                                      pow(princess.position.y - skeletonPosition.y, 2))
        
        if distanceToSkeleton < proximityThreshold {
            showDialogueBox2()
        } else {
            hideDialogueBox2()
        }
        

    }
    
    func movePrincessLeft() {
        if princess.position.x - princess.size.width / 2 > -size.width / 2 {
            princess.position.x -= 2.5
            
            if princess.action(forKey: "walking") == nil { // Only start if not already playing
                princess.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.1)), withKey: "walking")
            }
        }
    }
    
    func movePrincessRight() {
        if princess.position.x + princess.size.width / 2 < size.width / 2 {
            princess.position.x += 2.5
            
            if princess.action(forKey: "walking") == nil { // Only start if not already playing
                princess.run(SKAction.repeatForever(SKAction.animate(with: walkFrames, timePerFrame: 0.1)), withKey: "walking")
            }
        }
    }
    func showDialogueBox2() {
        dialogueBox2.alpha = 1
    }
    
    func hideDialogueBox2() {
        dialogueBox2.alpha = 0
    }
    
    func hideDialogueBox() {
        let waitAction = SKAction.wait(forDuration: 10.0)
        let fadeOutAction = SKAction.fadeOut(withDuration: 3.0)
        
        let sequence = SKAction.sequence([waitAction, fadeOutAction])
        dialogueBox.run(sequence)
    }
}
