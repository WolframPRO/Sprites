//
//  AxisNode.swift
//  Sprites
//
//  Created by Вова Петров on 30.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit

class AxisNode: SKShapeNode {
    
    override init() {
        super.init()
        self.strokeColor = .black
        self.lineWidth = 2
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func update() {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -1, y: -1000))
        path.addLine(to:  CGPoint(x: -1, y: 1000))
        path.move(to: CGPoint(x: -1000, y: -1))
        path.addLine(to:  CGPoint(x: 1000, y: -1))
        
        for x in -1000..<1000 {
            guard x % 20 == 0 else { continue }
            path.addRect(CGRect(x: x, y: -2, width: 1, height: 2))
            path.addRect(CGRect(x: -2, y: x, width: 2, height: 1))
        }
        
        self.path = path
    }
}
