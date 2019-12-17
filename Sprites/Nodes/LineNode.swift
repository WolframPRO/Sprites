//
//  LineNode.swift
//  Sprites
//
//  Created by Вова Петров on 30.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit

class LineNode: SKShapeNode, TranslationNodeProtocol {
    
    public var parentNode: CompodeNode?
    
    public var startSelected = false
    public var start: Point3D {
        didSet {
            update()
        }
    }
    public var endSelected = false
    public var end: Point3D {
        didSet {
            update()
        }
    }
    
    func copy() -> LineNode {
        let node = LineNode(start: start, end: end)
        self.parent?.addChild(node)
        return node
    }
    
    func deselectPoint() {
        self.startSelected = false
        self.endSelected = false
    }
    
    func move(for touch: UITouch, translation: Point3D) {
        let touchLocation = touch.location(in: self)
        if let point = self.arountEqualToExtremePoints(point: touchLocation.toPoint3D()) {
            if self.start == point {
                self.startSelected = true
            } else if self.end == point {
                self.endSelected = true
            }
        }
        
        let positionInScene = touch.location(in: self)
        
        if self.startSelected {
            self.start = Point3D(x: positionInScene.x, y: positionInScene.y, z: self.start.z)
        }
        else if self.endSelected {
            self.end = Point3D(x: positionInScene.x, y: positionInScene.y, z: self.end.z)
        }
        else {
            self.panForTranslation(translation)
        }
    }
    
    func panForTranslation(_ translation: Point3D) {
        
        start = start.plus(translation)
        end = end.plus(translation)
    }
    
    func arountEqualToExtremePoints(point: Point3D) -> Point3D? {
        if aroundEqual(first: start, second: point) {
           return start
        }
        else if aroundEqual(first: end, second: point) {
            return end
        }
        return nil
    }
    
    func aroundEqual(first: Point3D, second: Point3D) -> Bool {
        let firstX  = Int(first.x)
        let firstY  = Int(first.y)
        
        let secondX = Int(second.x)
        let secondY = Int(second.y)
        
        let deltaX = secondX - firstX
        let deltaY = secondY - firstY
        
        let matchY = deltaY < 5 && deltaY > -5
        let matchX = deltaX < 5 && deltaX > -5
        
        return matchY && matchX
    }
    
    public func setLine(start: Point3D, end: Point3D) {
        self.start = start
        self.end = end
    }
    
    init(start: Point3D, end: Point3D, color: UIColor = .blue, width: CGFloat = 5.0) {
        self.start = start
        self.end = end
        super.init()
        self.strokeColor = color
        self.lineWidth = width
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Z
    func zChanged(to zValue: CGFloat, isLast: Bool) {
        let firstCoord = Point3D(x: start.x, y: start.y, z: isLast ? start.z : zValue)
        let lastCoord = Point3D(x: end.x, y: end.y, z: isLast ? zValue : end.z)
        start = firstCoord
        end = lastCoord
    }
    
    private func update() {
        let path = CGMutablePath()
        path.move(to: start.toPoint2D())
        path.addLine(to:  end.toPoint2D())
        path.addEllipse(in: CGRect(x: start.x-2, y: start.y-2, width: 4, height: 4))
        path.addEllipse(in: CGRect(x: end.x-2, y: end.y-2, width: 4, height: 4))
        self.path = path
        
        let def = Math2D.lineDefinition(between: start.toPoint2D(), and: end.toPoint2D())
        let lineDef = "\(Int(def.A))x + \(Int(def.B))y + \(Int(def.C)) = 0"
        Radio.post(lineDef: lineDef)
        Radio.post(selectedPoint: start, end: end)
    }
}

///Выбор ноды
extension LineNode {
    func selectNode(oldSelected: TranslationNodeProtocol?) -> TranslationNodeProtocol {
        oldSelected?.strokeColor = .blue
        
        let node = selectNodeWithoutColorize(oldSelected: oldSelected)
        node.strokeColor = .red

        Radio.post(selectedPoint: start, end: end)
        return node
    }
    
    private func selectNodeWithoutColorize(oldSelected: TranslationNodeProtocol?) -> TranslationNodeProtocol {
        if let parent = parentNode {
            return parent.selectNode(oldSelected: oldSelected)
        }
        
        guard StateMachine.state == .group else {
            return self
        }
        
        switch oldSelected {
        case let oldSelected as LineNode:
            let compodeNode = CompodeNode()
            compodeNode.add(node: oldSelected)
            if oldSelected != self {
                compodeNode.add(node: self)
            }
            return compodeNode
        case let oldSelected as CompodeNode:
            oldSelected.add(node: self)
            return oldSelected
        default:
            return self
        }
    }
}
