//
//  Radio.swift
//  Sprites
//
//  Created by Вова Петров on 01.11.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import Foundation

class Radio {
    
    static func post(morfingValue: Int) {
        let notification = Notification(name: Notification.Name(rawValue: "morfing_value"),
                                        object: nil,
                                        userInfo: ["morfingValue":morfingValue])
        NotificationCenter.default.post(notification)
    }
    
    static func post(lineDef: String) {
        let notification = Notification(name: Notification.Name(rawValue: "fx_line"),
                                        object: nil,
                                        userInfo: ["string":lineDef])
        NotificationCenter.default.post(notification)
    }
    
    static func post(selectedPoint first: Point3D, end: Point3D) {
        let notification = Notification(name: Notification.Name(rawValue: "selectedPoint"),
                                        object: nil,
                                        userInfo: ["first": first,
                                                   "end": end])
        NotificationCenter.default.post(notification)
    }
    
    static func postNodeHaveParent() {
        let notification = Notification(name: Notification.Name(rawValue: "node_have_parent"),
                                        object: nil,
                                        userInfo: ["isOn":true])
        NotificationCenter.default.post(notification)
    }
    
    class Subscribe {
        
        static func morfingValue(block: @escaping (Int)->()) {
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "morfing_value"), object: nil, queue: .main) { (notification) in
                block(notification.userInfo!["morfingValue"]! as! Int)
            }
        }
        
        static func selectedPoint(block: @escaping ((first: Point3D, end: Point3D))->()) {
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "selectedPoint"), object: nil, queue: .main) { (notification) in
                block((notification.userInfo!["first"]! as! Point3D, notification.userInfo!["end"]! as! Point3D))
            }
        }
        
        
        static func fxLine(block: @escaping (String)->()) {
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fx_line"), object: nil, queue: .main) { (notification) in
                block("Уравнение прямой: \(notification.userInfo!["string"]! as! String)")
            }
        }
        
        
        static func nodeHaveParent(block: @escaping (Bool)->()) {
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "node_have_parent"), object: nil, queue: .main) { (notification) in
                block(true)
            }
        }
    }
}
