//
//  GameScene.swift
//  Sprites
//
//  Created by Вова Петров on 03.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TranslationNodeProtocol: SKNode {
    func panForTranslation(_ translation: CGPoint)
}

class GameScene: SKScene {
    
	var selectedNode: TranslationNodeProtocol?
    var axisNode = AxisNode()
    
    func setAxis(hidden: Bool) {
        axisNode.isHidden = hidden
    }
    
    func afterInit() {
        self.addChild(axisNode)
    }
    
	public func addLine() {
		let line = LineNode(start: CGPoint(x: 0, y: -100), end: CGPoint(x: 0, y: 100))
		self.addChild(line)
    }
	
	public func removeLine() -> Bool {
		guard selectedNode != nil else {
			return false
		}
		selectedNode!.removeFromParent()
		return true
	}
	
    func move(for first: UITouch, and last: UITouch) {
		guard let selectedNode = selectedNode else {
			return
		}
        let firstCoord = first.location(in: self)
        let lastCoord = last.location(in: self)
        
        if selectedNode is LineNode {
            (selectedNode as! LineNode).setLine(start: firstCoord, end: lastCoord)
        }
    }
        
    func move(for touch: UITouch) {
        guard let selectedNode = selectedNode else { return }
        
        if let point = selectedNode.arountEqualToExtremePoints(point: touch.location(in: selectedNode)) {
            if selectedNode.start.equalTo(point) {
                selectedNode.startSelected = true
            } else if selectedNode.end.equalTo(point) {
                selectedNode.endSelected = true
            }
        }
        
        let positionInScene = touch.location(in: self)
        
        if selectedNode.startSelected {
                selectedNode.start = positionInScene
        }
        else if selectedNode.endSelected {
                selectedNode.end = positionInScene
        }
        else {
            let previousPosition = touch.previousLocation(in: self)
            
            guard self.atPoint(previousPosition) == selectedNode else { return }
            let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
                
            selectedNode.panForTranslation(translation)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
		selectNodeForTouch(touchLocation: pos)
        
        let notification = Notification(name: Notification.Name(rawValue: "selectedPoint"),
                                        object: nil,
                                        userInfo: ["x": pos.x, "y": pos.y])
        NotificationCenter.default.post(notification)
    }
    
    func selectNodeForTouch(touchLocation : CGPoint) {
        guard let touchedNode = self.atPoint(touchLocation) as? LineNode else {
            return
        }
        
        if let selectedNode = selectedNode {
            selectedNode.strokeColor = .blue
        }
        
        selectedNode = touchedNode
        selectedNode!.strokeColor = .red
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let notification = Notification(name: Notification.Name(rawValue: "selectedPoint"),
                                        object: nil,
                                        userInfo: ["x": pos.x, "y": pos.y])
        NotificationCenter.default.post(notification)
		
    }
    
    func touchUp(atPoint pos : CGPoint) {
        guard let selectedNode = selectedNode else { return }
        selectedNode.deselectPoint()
    }
	
	override func didMove(to view: SKView) {
		
    }
}

extension GameScene {
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
