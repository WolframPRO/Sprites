//
//  Radio.swift
//  Sprites
//
//  Created by Вова Петров on 01.11.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import Foundation

class Radio {
    static func post(lineDef: String) {
        let notification = Notification(name: Notification.Name(rawValue: "fx_line"),
                                        object: nil,
                                        userInfo: ["string":lineDef])
        NotificationCenter.default.post(notification)
    }
    
    static func post(selectedPoint: CGPoint) {
        let notification = Notification(name: Notification.Name(rawValue: "selectedPoint"),
                                        object: nil,
                                        userInfo: ["x": selectedPoint.x, "y": selectedPoint.y])
        NotificationCenter.default.post(notification)
    }
    
    static func postNodeHaveParent() {
        let notification = Notification(name: Notification.Name(rawValue: "node_have_parent"),
                                        object: nil,
                                        userInfo: ["isOn":true])
        NotificationCenter.default.post(notification)
    }
    
    class Subscribe {
        static func selectedPoint(block: @escaping (String)->()) {
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "selectedPoint"), object: nil, queue: .main) { (notification) in
                block("Выбрана точка: x:\(Int(notification.userInfo!["x"]! as! CGFloat)) y:\(Int(notification.userInfo!["y"]! as! CGFloat))")
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
