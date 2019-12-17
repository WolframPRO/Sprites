//
//  CompositeNode.swift
//  Sprites
//
//  Created by Вова Петров on 30.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit

class CompodeNode: TranslationNodeProtocol {
    
    var nodes: [LineNode] = []
    
    func selectNode(oldSelected: TranslationNodeProtocol?) -> TranslationNodeProtocol {
        Radio.postNodeHaveParent()
        return self
    }
    
    func add(node: LineNode) {
        weak var weakSelf = self
        node.parentNode = weakSelf
        nodes.append(node)
    }
    
    func removeAll() {
        nodes.forEach { $0.parentNode = nil; $0.strokeColor = .blue }
        nodes.removeAll()
    }
    
    func removeFromParent() {
        nodes.forEach { $0.removeFromParent(); $0.parentNode = nil }
        nodes.removeAll()
    }
    
    func move(for touch: UITouch, translation: Point3D) {
        self.panForTranslation(translation)
    }
    
    func panForTranslation(_ translation: Point3D) {
        weak var weakSelf = self
        for node in nodes {
            node.parentNode = weakSelf
            node.panForTranslation(translation)
        }
    }
    
    var strokeColor: UIColor = .blue {
        didSet {
            nodes.forEach { $0.strokeColor = self.strokeColor.mix(with: .green) }
        }
    }
    
    // MARK:- Z
    func zChanged(to zValue: CGFloat, isLast: Bool) {}
}
