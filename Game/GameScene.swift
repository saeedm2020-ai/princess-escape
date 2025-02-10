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
        //background.blendMode = .replace
        background.zPosition = -1
        //        background.size.width = view.frame.width * 1.5
        //background.size.height = view.frame.height / 2
        addChild(background)
        //
        //        let foreground = SKSpriteNode(imageNamed: "foreground.jpg")
        //        foreground.position = CGPoint(x: size.width - 500, y: 500)
        //        foreground.zPosition = 0
        //        addChild(foreground)
        
        
        princess = SKSpriteNode(imageNamed: "princess.png")
        princess.position = CGPoint(x: -300, y: -100)
        addChild(princess)
        
        let Wisp = SKSpriteNode(imageNamed: "Wisp.png")
        Wisp.position = CGPoint(x: 0, y: -20)
        addChild(Wisp)
        
        let hearts = SKSpriteNode(imageNamed: "hearts.png")
        hearts.position = CGPoint(x: -300, y: 40)
        addChild(hearts)
        
        leftArrowButton = SKSpriteNode(imageNamed: "leftarrowbutton")
        leftArrowButton.position = CGPoint(x: -320, y: -150)
        self.addChild(leftArrowButton)
        
        
        
        rightArrowButton = SKSpriteNode(imageNamed: "rightarrowbutton")
        rightArrowButton.position = CGPoint(x: 320, y: -150)
        self.addChild(rightArrowButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // Reset movement flags to prevent moving outside of buttons
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
                
                // Check if the touch is on the left arrow
                if leftArrowButton.contains(touchLocation) {
                    isLeftArrowButtonPressed = isTouching
                }
                
                // Check if the touch is on the right arrow
                else if rightArrowButton.contains(touchLocation) {
                    isRightArrowButtonPressed = isTouching
                }
            }
        }
        
        override func update(_ currentTime: TimeInterval) {
            // Move the princess only when the corresponding button is pressed
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
