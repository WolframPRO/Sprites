//
//  GameScene.swift
//  Sprites
//
//  Created by Вова Петров on 03.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TranslationNodeProtocol: AnyObject {
    func move(for touch: UITouch, translation: CGPoint)
    var strokeColor: UIColor { get set }
    func removeFromParent()
}

class GameScene: SKScene {
    
	var selectedNode: TranslationNodeProtocol?
    var axisNode = AxisNode()

	public func addLine() {
        let start = CGPoint(x: Int.random(in: -100...100), y: Int.random(in: -100...100))
        let end = CGPoint(x: Int.random(in: -100...100), y: Int.random(in: -100...100))
		let line = LineNode(start: start, end: end)
		self.addChild(line)
    }
	
	public func removeNode() -> Bool {
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
        
        let previousPosition = touch.previousLocation(in: self)
        let positionInScene = touch.location(in: self)
        
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        selectedNode.move(for: touch, translation: translation)
    }
    
    func touchDown(atPoint pos : CGPoint) {
		selectNodeForTouch(touchLocation: pos)
        Radio.post(selectedPoint: pos)
    }
    
    func selectNodeForTouch(touchLocation : CGPoint) {
        guard let touchedNode = self.atPoint(touchLocation) as? LineNode else { return }
        self.selectedNode = touchedNode.selectNode(oldSelected: self.selectedNode)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        Radio.post(selectedPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        guard let selectedNode = selectedNode else { return }
        if selectedNode is LineNode {
            (selectedNode as! LineNode).deselectPoint()
        }
    }
	
	override func didMove(to view: SKView) {
		
    }
}

///Оси координат
extension GameScene {
    
    func setAxis(hidden: Bool) {
        axisNode.isHidden = hidden
    }
    
    func afterInit() {
        self.addChild(axisNode)
    }
    
}

///Группировка
extension GameScene {
    func ungroup() {
        guard let selectedNode = selectedNode else { return }
        
        switch selectedNode {
        case let node as CompodeNode:
            node.removeAll()
            self.selectedNode?.strokeColor = .blue
            self.selectedNode = nil
        default:
            return
        }
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
