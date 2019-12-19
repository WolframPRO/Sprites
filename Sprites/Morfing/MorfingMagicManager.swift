//
//  MorfingMagicManager.swift
//  Sprites
//
//  Created by Вова Петров on 17.12.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit
import GameplayKit

class MorfingMagicManager {
    var start: ComposeNode?
    var clearStart: ComposeNode?
    var balancedStart: ComposeNode?
    
    var end: ComposeNode?
    var fakeStartNode: ComposeNode?
    
    enum MorfingError: Error {
        case noFirstNode
        case noEndNode
        case percentGreatherThanOne
        case percentLessThanZero
    }
    
    deinit {
        start?.nodes.forEach { $0.removeFromParent() }
        clearStart?.nodes.forEach { $0.removeFromParent() }
        balancedStart?.nodes.forEach { $0.removeFromParent() }
        end?.nodes.forEach { $0.removeFromParent() }
    }
    
    init() {
        Radio.Subscribe.morfingValue {[weak self] (value) in
            do {
                try self?.magic(CGFloat(value)/100)
            } catch {}
        }
    }
    
    func set(start: ComposeNode) {
        let node = ComposeNode()
        clearStart = ComposeNode()
        balancedStart = ComposeNode()
        node.nodes              = start.nodes.map { $0.copy() }
        clearStart?.nodes       = start.nodes.map { $0.copy() }
        balancedStart?.nodes    = start.nodes.map { $0.copy() }
        node.nodes.forEach { $0.strokeColor = UIColor.red.mix(with: .blue) }
        self.start = node
    }
    
    func set(end: ComposeNode) {
        let node = ComposeNode()
        node.nodes = end.nodes.map { $0.copy() }
        node.nodes.forEach { $0.strokeColor = UIColor.red.mix(with: .blue) }
        self.end = node
    }
    
    func balance() throws {
        guard let start = start else { throw MorfingError.noFirstNode }
        guard let end = end else { throw MorfingError.noEndNode }
        
        if start.nodes.count == end.nodes.count { return }
        
        if start.nodes.count > end.nodes.count {
            let delta = start.nodes.count - end.nodes.count
            (0..<delta).forEach { _ in
                if let last = end.nodes.last {
                    //TODO: Проверить добавление на сцену
                    end.nodes.append(last.copy())
                }
            }
        }
        
        if  end.nodes.count > start.nodes.count {
            let delta = end.nodes.count - start.nodes.count
            (0..<delta).forEach { _ in
                if let last = start.nodes.last {
                    //TODO: Проверить добавление на сцену
                    balancedStart?.nodes.append(last.copy())
                    start.nodes.append(last.copy())
                }
            }
        }
    }
    
    func magic(_ percent: CGFloat) throws {
        guard percent <= 1 else { throw MorfingError.percentGreatherThanOne }
        guard percent >= 0 else { throw MorfingError.percentLessThanZero }
        
        try balance()
        
        guard let start = start else { throw MorfingError.noFirstNode }
        guard let end = end else { throw MorfingError.noEndNode }
        
        
        balancedStart!.nodes.enumerated().forEach {
            let startNodeBalanced = $0.element
            let startNode = start.nodes[$0.offset]
            let endNode = end.nodes[$0.offset]
            
            let startPoint = self.makeMagic(first: startNodeBalanced.start, last: endNode.start, percent: percent)
            let endPoint = self.makeMagic(first: startNodeBalanced.end, last: endNode.end, percent: percent)
            
            startNode.setLine(start: startPoint, end: endPoint)
        }
    }
    
    private func makeMagic(first: Point3D, last: Point3D, percent: CGFloat) -> Point3D {
        let x = makeMagic(first: first.x, last: last.x, percent: percent)
        let y = makeMagic(first: first.y, last: last.y, percent: percent)
        let z = makeMagic(first: first.z, last: last.z, percent: percent)
        return Point3D(x: x, y: y, z: z)
    }
    
    private func makeMagic(first: CGFloat, last: CGFloat, percent: CGFloat) -> CGFloat {
        return first * (1-percent) + last * percent
    }
}
