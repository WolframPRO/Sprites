//
//  LineNode.swift
//  Sprites
//
//  Created by Вова Петров on 30.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit

class LineNode: SKShapeNode {
    public var startSelected = false
    public var start: CGPoint {
        didSet {
            update()
        }
    }
    public var endSelected = false
    public var end: CGPoint {
        didSet {
            update()
        }
    }
    
    func deselectPoint() {
        self.startSelected = false
        self.endSelected = false
    }
    
    func arountEqualToExtremePoints(point: CGPoint) -> CGPoint? {
        if aroundEqual(first: start, second: point) {
           return start
        }
        else if aroundEqual(first: end, second: point) {
            return end
        }
        return nil
    }
    
    func aroundEqual(first: CGPoint, second: CGPoint) -> Bool {
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
    
    public func setLine(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
    
    init(start: CGPoint, end: CGPoint, color: UIColor = .blue, width: CGFloat = 10.0) {
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
    
    private func update() {
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to:  end)
        path.addEllipse(in: CGRect(x: start.x-5, y: start.y-5, width: 10, height: 10))
        path.addEllipse(in: CGRect(x: end.x-5, y: end.y-5, width: 10, height: 10))
        self.path = path
        
        let def = CustomMath.lineDefinition(between: start, and: end)
        let lineDef = "\(Int(def.A))x + \(Int(def.B))y + \(Int(def.C)) = 0"
        let notification = Notification(name: Notification.Name(rawValue: "fx_line"),
                                        object: nil,
                                        userInfo: ["string":lineDef])
        NotificationCenter.default.post(notification)
    }
}
