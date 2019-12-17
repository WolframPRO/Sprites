//
//  PublicGameScene.swift
//  Sprites
//
//  Created by Вова Петров on 14.12.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit
import GameplayKit

///Паблик методы
extension GameScene {
    
    public func updateRadioState() {
        guard let node = selectedNode as? LineNode else { return }
        
        let def = Math3D.lineDefinition(between: node.start, and: node.end)
        let lineDef = "\(Int(def.point.x))x + \(Int(def.point.y))y + \(Int(def.point.z))z"
        Radio.post(lineDef: lineDef)
        Radio.post(selectedPoint: node.start, end: node.end)
    }
    
    // MARK:- z
    public func zChanged(to zValue: CGFloat, isLast: Bool) {
        selectedNode?.zChanged(to: zValue, isLast: isLast)
    }
    
    public func addLine() {
        let start = CGPoint(x: Int.random(in: -100...100), y: Int.random(in: -100...100))
        let end = CGPoint(x: Int.random(in: -100...100), y: Int.random(in: -100...100))
        let line = LineNode(start: start.toPoint3D(), end: end.toPoint3D())
        self.addChild(line)
    }
    
    public func removeNode() -> Bool {
        guard selectedNode != nil else {
            return false
        }
        selectedNode!.removeFromParent()
        selectedNode = nil
        return true
    }
    
    ///Оси координат
    func setAxis(hidden: Bool) {
        axisNode.isHidden = hidden
    }
    
    func afterInit() {
        self.addChild(axisNode)
        
        StateMachine.Subscribe.isMorfingState {[weak self] (morfing) in
            if morfing {
                self?.morfingManager = MorfingMagicManager()
            } else {
                self?.morfingManager = nil
            }
        }
    }

    ///Группировка
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
