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

typealias Point2D = CGPoint
extension CGPoint {
    func toPoint3D(_ z: CGFloat = 0) -> Point3D {
        return Point3D(x: x, y: y, z: z)
    }
}

class Point3D: NSObject, NSCoding  {
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(Float(x), forKey: "x")
        coder.encode(Float(y), forKey: "y")
        coder.encode(Float(z), forKey: "z")
    }
    
    convenience required init?(coder: NSCoder) {
        let x2 = CGFloat(coder.decodeFloat(forKey: "x"))
        let y2 = CGFloat(coder.decodeFloat(forKey: "y"))
        let z2 = CGFloat(coder.decodeFloat(forKey: "z"))
        self.init(x: x2, y: y2, z: z2)
    }
    
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
    
    func toPoint2D() -> Point2D {
        return Point2D(x: CGFloat(x), y: CGFloat(y))
    }
}

// MARK:- 3 Dimension
class Math3D {
    struct LineDefinition {
        let vector: Vector
        let point: Point3D
    }
    
    struct Vector {
        let m: CGFloat
        let n: CGFloat
        let p: CGFloat
    }
    
    static func distance(between: Point3D, and: Point3D) -> CGFloat {
        let xa = between.x
        let ya = between.y
        let za = between.z
        let xb = and.x
        let yb = and.y
        let zb = and.z
        
        let distance = (pow((xb - xa), 2) + pow((yb - ya), 2) + pow((zb - za), 2)).squareRoot()
        return distance
    }
    
    static func lineDefinition(between: Point3D, and: Point3D) -> LineDefinition {
        let xa = CGFloat(Int(between.x))
        let ya = CGFloat(Int(between.y))
        let za = CGFloat(Int(between.z))
        let xb = CGFloat(Int(and.x))
        let yb = CGFloat(Int(and.y))
        let zb = CGFloat(Int(and.z))

        let vector = Vector(m: xa - xb, n: ya - yb, p: za - zb)
        
        return LineDefinition(vector: vector, point: and)
    }
    
    static func distance(between line: LineDefinition, and point: Point3D) -> CGFloat {
        let lineVector = line.vector
        let linePoint = line.point

        let m0m1 = Vector(m: linePoint.x - point.x, n: linePoint.y - point.y, p: linePoint.z - point.z)
        let m0m1xs = Vector(m: m0m1.n * lineVector.p - lineVector.n * m0m1.p,
                            n: m0m1.m * lineVector.p - lineVector.m * m0m1.p,
                            p: m0m1.m * lineVector.n - lineVector.m * m0m1.n)
        
        let distanceOf_m0m1xs = (m0m1xs.m*m0m1xs.m + m0m1xs.n*m0m1xs.n + m0m1xs.p*m0m1xs.p).squareRoot()
        let distanceOf_lineVector = (lineVector.m*lineVector.m
            + lineVector.n*lineVector.n
            + lineVector.p*lineVector.p).squareRoot()
        
        return distanceOf_m0m1xs / distanceOf_lineVector
    }
}

class Math2D {

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
