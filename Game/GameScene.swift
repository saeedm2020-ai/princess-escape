//
//  GameScene.swift
//  Game
//
//  Created by Saeed Mohamed on 2/3/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Declare the sprites for the princess, left and right arrows
    var princess: SKSpriteNode!
    var leftArrowButton: SKSpriteNode!
    var rightArrowButton: SKSpriteNode!
    
    // Flags to track whether a button is pressed or held
    var isLeftArrowButtonPressed = false
    var isRightArrowButtonPressed = false
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 70, y: 50)
        background.blendMode = .replace
        background.zPosition = -1
        //        background.size.width = view.frame.width * 1.5
        background.size.height = view.frame.height / 1
        addChild(background)
        
        princess = SKSpriteNode(imageNamed: "princess.png")
        princess.position = CGPoint(x: -280, y: -30)
        princess.zPosition = 1
        addChild(princess)
        
        let Wisp = SKSpriteNode(imageNamed: "Wisp.png")
        Wisp.position = CGPoint(x: 0, y: 0)
        addChild(Wisp)
        
        let hearts = SKSpriteNode(imageNamed: "hearts.png")
        hearts.position = CGPoint(x: -280, y: 130)
        addChild(hearts)
        
        leftArrowButton = SKSpriteNode(imageNamed: "leftarrowbutton")
        leftArrowButton.position = CGPoint(x: -320, y: -70)
        leftArrowButton.zPosition = 2
        self.addChild(leftArrowButton)
        
        rightArrowButton = SKSpriteNode(imageNamed: "rightarrowbutton")
        rightArrowButton.position = CGPoint(x: 350, y: -70)
        rightArrowButton.zPosition = 2
        self.addChild(rightArrowButton)
        
        
        let dialoguebox = SKSpriteNode(imageNamed: "dialoguebox.png")
        dialoguebox.position = CGPoint(x: -140, y: -170)
        dialoguebox.zPosition = 3
        addChild(dialoguebox)
        
        
        
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

