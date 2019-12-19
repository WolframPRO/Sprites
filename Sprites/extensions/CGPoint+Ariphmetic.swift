//
//  CGPoint+Ariphmetic.swift
//  Sprites
//
//  Created by Влада Кузнецова on 03/10/2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit
import GameplayKit

extension CGPoint {
    func plus(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x + self.x, y: point.y + self.y)
    }
}

extension Point3D {
    func plus(_ point: Point3D) -> Point3D {
        return Point3D(x: point.x + self.x, y: point.y + self.y, z: point.z + self.z)
    }
    
//    static func == (lhs: Point3D, rhs: Point3D) -> Bool {
//        lhs.x == rhs.x && lhs.y == rhs.y
//    }
}
