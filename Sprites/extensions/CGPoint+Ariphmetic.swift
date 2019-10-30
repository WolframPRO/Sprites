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

