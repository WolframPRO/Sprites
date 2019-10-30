//
//  CustomMath.swift
//  Sprites
//
//  Created by Вова Петров on 30.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit

class CustomMath {

    struct LineDefinition {
        let A: CGFloat
        let B: CGFloat
        let C: CGFloat
    }


    static func distance(between: CGPoint, and: CGPoint) -> CGFloat {
        let xa = between.x
        let ya = between.y
        let xb = and.x
        let yb = and.y

        let distance = (pow((xb - xa), 2) + pow((yb - ya), 2)).squareRoot()
        return distance
    }

    static func lineDefinition(between: CGPoint, and: CGPoint) -> LineDefinition {
        let xa = CGFloat(Int(between.x))
        let ya = CGFloat(Int(between.y))
        let xb = CGFloat(Int(and.x))
        let yb = CGFloat(Int(and.y))
        
        if xa - xb == 0 {
            return LineDefinition(A: 1, B: 0, C: -xb)
        }
        
        if ya - yb == 0 {
            return LineDefinition(A: 0, B: 1, C: -yb)
        }

        let k = (ya - yb) / (xa - xb)
        let b = yb - k*xb

        // now we have y = kb + b or kx - 1y + b = 0
        // so k -> a, -1 -> b, b -> c

        let A = k * (xa - xb)
        let B = -1 * (xa - xb)
        let C = b * (xa - xb)

        return LineDefinition(A: A, B: B, C: C)
    }

    static func distance(between line: LineDefinition, and point: CGPoint) -> CGFloat {
        let Mx = point.x
        let My = point.y
        let A = line.A
        let B = line.B
        let C = line.C

        let znamen = abs(A * Mx + B * My + C)
        let chisl = (pow(A, 2) + pow(B, 2)).squareRoot()

        return znamen / chisl
    }
}
