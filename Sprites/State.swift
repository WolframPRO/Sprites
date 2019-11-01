//
//  State.swift
//  Sprites
//
//  Created by Вова Петров on 01.11.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import Foundation

class State {
    
    lazy var shared = State()
    private init() {}
    
    static var isGroupState = false {
        didSet {
            post(isGroupState: State.isGroupState)
        }
    }
    
    private static func post(isGroupState: Bool) {
        let notification = Notification(name: Notification.Name(rawValue: "isGroupState"),
                                        object: nil,
                                        userInfo: ["isGroupState":isGroupState])
        NotificationCenter.default.post(notification)
    }
    
    class Subscribe {
        static func isGroupState(block: @escaping (Bool)->()) {
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "isGroupState"), object: nil, queue: .main) { (notification) in
                block(notification.userInfo!["isGroupState"]! as! Bool)
            }
        }
    }
}
