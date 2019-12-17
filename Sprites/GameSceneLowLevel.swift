//
//  GameSceneLowLevel.swift
//  Sprites
//
//  Created by Вова Петров on 14.12.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchesArr = Array(touches)

        if touches.count == 1 {
            let touch = touchesArr[0]
            move(for: touch)
        }

        if touches.count == 2 {
            let firstFinger = touchesArr[0]
            let lastFinger = touchesArr[1]
            move(for: firstFinger, and: lastFinger)
        }
        
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
