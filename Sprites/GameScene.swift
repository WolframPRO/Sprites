//
//  GameScene.swift
//  Sprites
//
//  Created by Вова Петров on 03.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TranslationNodeProtocol: NSObject {
    func move(for touch: UITouch, translation: Point3D)
    var strokeColor: UIColor { get set }
    func removeFromParent()
    func zChanged(to zValue: CGFloat, isLast: Bool)
}

class GameScene: SKScene {
    
	var selectedNode: TranslationNodeProtocol?
    var axisNode = AxisNode()
    
    var morfingManager: MorfingMagicManager?
	
    func move(for first: UITouch, and last: UITouch) {
//		guard let selectedNode = selectedNode else {
//			return
//		}
//        let firstCoord = first.location(in: self)
//        let lastCoord = last.location(in: self)
//
//        if selectedNode is LineNode {
//            (selectedNode as! LineNode).setLine(start: firstCoord, end: lastCoord)
//        }
    }
        
    func move(for touch: UITouch) {
        guard let selectedNode = selectedNode else { return }
        
        let previousPosition = touch.previousLocation(in: self)
        let positionInScene = touch.location(in: self)
        
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        selectedNode.move(for: touch, translation: translation.toPoint3D())
    }
    
    func touchDown(atPoint pos : CGPoint) {
        Radio.post(selectedPoint: pos.toPoint3D(), end: pos.toPoint3D())
		selectNodeForTouch(touchLocation: pos)
    }
    
    func selectNodeForTouch(touchLocation : CGPoint) {
        guard let touchedNode = getLineAt(touchLocation) else { return }
        self.selectedNode = touchedNode.selectNode(oldSelected: self.selectedNode)
        
        if StateMachine.state == .morfing,
            let compodeMode = self.selectedNode as? ComposeNode  {
            selectNodeForMorfing(node: compodeMode)
        }
    }
    
    func selectNodeForMorfing(node: ComposeNode) {
        guard var manager = morfingManager else { return }
        
        if manager.start == nil {
            manager.set(start: node)
        }
        else if manager.end == nil {
            manager.set(end: node)
        }
        else {
            morfingManager = nil
            manager = MorfingMagicManager()
            morfingManager = manager
            
            manager.set(start: node)
        }
    }
    
    func getLineAt(_ touchLocation: CGPoint) -> LineNode? {
        let wrappedNodes = self.nodes(at: touchLocation)
        var nodes = [LineNode]()
        for node in wrappedNodes {
            guard let unwNode = node as? LineNode else { continue }
            nodes.append(unwNode)
        }
        
        var findedNode: LineNode?
        
        for node in nodes {
            guard let nodepath = node.path else {
                continue
            }

            let points = nodepath.getPathElementsPoints()
            let line = Math2D.lineDefinition(between: points[0], and: points[1])
            let distance = Math2D.distance(between: line, and: touchLocation)
            
            if distance < 20 {
                findedNode = node
                break
            }
        }
        
        return findedNode
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
