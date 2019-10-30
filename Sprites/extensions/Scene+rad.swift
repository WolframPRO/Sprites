//
//  Scene+.swift
//  Sprites
//
//  Created by Влада Кузнецова on 03/10/2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func degToRad(_ degree: Double) -> CGFloat {
        return CGFloat(degree / 180.0 * Double.pi)
    }
}
