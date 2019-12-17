//
//  State.swift
//  Sprites
//
//  Created by Вова Петров on 01.11.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import Foundation

class StateMachine {
    
    enum State {
        case normal
        case morfing
        case group
    }
    
    lazy var shared = StateMachine()
    private init() {}
    
    static var state: State = .normal {
        didSet {
            switch state {
            case .morfing:
                post(isMorfingMode: true)
                post(isGroupState: false)
            case .group:
                post(isMorfingMode: false)
                post(isGroupState: true)
            default:
                post(isMorfingMode: false)
                post(isGroupState: false)
            }
        }
    }
    
    static func post(isMorfingMode: Bool) {
        let notification = Notification(name: Notification.Name(rawValue: "morfing_mode"),
                                        object: nil,
                                        userInfo: ["isMorfing":isMorfingMode])
        NotificationCenter.default.post(notification)
    }
    
    private static func post(isGroupState: Bool) {
        let notification = Notification(name: Notification.Name(rawValue: "isGroupState"),
                                        object: nil,
                                        userInfo: ["isGroupState":isGroupState])
        NotificationCenter.default.post(notification)
    }
    
    class Subscribe {
        static func isMorfingState(block: @escaping (Bool)->()) {
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "morfing_mode"), object: nil, queue: .main) { (notification) in
                block(notification.userInfo!["isMorfing"]! as! Bool)
            }
        }
        
        static func isGroupState(block: @escaping (Bool)->()) {
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "isGroupState"), object: nil, queue: .main) { (notification) in
                block(notification.userInfo!["isGroupState"]! as! Bool)
            }
        }
    }
}
