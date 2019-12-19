//
//  CompositeNode.swift
//  Sprites
//
//  Created by Вова Петров on 30.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit

class ComposeNode: NSObject, TranslationNodeProtocol, NSCoding {
    
    var justTry: [CGFloat] = []
    var justTry2: [Point3D] = []
    
    var nodes: [LineNode] = []
    
    func encode(with coder: NSCoder) {
        let ns = NSArray(array: nodes)
        coder.encode(ns, forKey: "nodes")
        
        let waawdawd: [CGFloat] = [1.0 , 2.0]
        coder.encode(waawdawd, forKey: "justTry")
        
        let addwawd: [Point3D] = [Point3D(x: 1, y: 2, z: 3), Point3D(x: 4, y: 5, z: 6)]
        coder.encode(addwawd, forKey: "justTry2")

    }
    
    convenience required init?(coder: NSCoder) {
        let lines = coder.decodeObject(of: [NSArray.self], forKey: "nodes")

        self.init()

        if let strongLines = lines,
            let typed = strongLines as? [LineNode] {
            nodes = typed
        }
    }
    
    func selectNode(oldSelected: TranslationNodeProtocol?) -> TranslationNodeProtocol {
        Radio.postNodeHaveParent()
        return self
    }
    
    func add(node: LineNode) {
        weak var weakSelf = self
        node.parentNode = weakSelf
        self.nodes.append(node)
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
