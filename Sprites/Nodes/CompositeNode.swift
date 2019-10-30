//
//  CompositeNode.swift
//  Sprites
//
//  Created by Вова Петров on 30.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import Foundation

class CompodeNode {
    var nodes: [LineNode] = []
    
    func add(node: LineNode) {
        nodes.append(node)
    }
    
    func removeAll() {
        nodes.removeAll()
    }
    
    func panForTranslation(_ translation: CGPoint) {
        weak var weakSelf = self
        for node in nodes {
            node.parentNode = weakSelf
            node.panForTranslation(translation)
        }
    }
}
