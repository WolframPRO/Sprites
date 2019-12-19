//
//  RestoreManager.swift
//  Sprites
//
//  Created by Вова Петров on 19.12.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import Foundation
import SpriteKit

class RestoreManager {
    static var shared = RestoreManager()
    
    private var nodesCollection = NSHashTable<NSObject>.weakObjects()
    private var scene: SKScene!
    
    private init() {}
    
    func add(to scene: SKScene) {
        self.scene = scene
        restore()
    }
    
    func add(line: NSObject) {
        nodesCollection.add(line)
        store()
    }
    
    func remove(line: NSObject) {
        nodesCollection.remove(line)
        store()
    }
    
    func store() {
        let data = nodesCollection.allObjects.filter { (obj) -> Bool in
            if let line = obj as? LineNode,
                line.parentNode != nil {
                return false
            }
            return true
        }
        
        let encodedData: Data? = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
        
        guard let encoded = encodedData else { return }
        
        UserDefaults.standard.set(encoded, forKey: Constants.userDefaultSaverName)
        UserDefaults.standard.synchronize()
    }
    
    func restore() {
        guard let decoded = UserDefaults.standard.data(forKey: Constants.userDefaultSaverName),
            let savedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [NSObject]
            else { return }
        
        redraw(with: savedData)
    }
    
    private func redraw(with nodes: [NSObject]) {
        var simpleNodes = [LineNode]()
        var composeNodes = [ComposeNode]()
        
        for node in nodes {
            if let simpleNode = node as? LineNode,
                simpleNode.parent == nil {
                simpleNodes.append(simpleNode)
            }
            else if let composeNode = node as? ComposeNode {
                composeNodes.append(composeNode)
            }
        }
        
        for node in simpleNodes {
            node.addAfterDecoderInit(to: scene)
            nodesCollection.add(node)
        }
        
        for node in composeNodes {
            let newCom = ComposeNode()
            for simpl in node.nodes {
                let ln = LineNode.line(to: scene, startPoint: simpl.start, endPoint: simpl.end)
                ln.group(into: newCom)
                nodesCollection.add(ln)
            }
            newCom.strokeColor = .blue
            nodesCollection.add(newCom)
        }

    }
}
