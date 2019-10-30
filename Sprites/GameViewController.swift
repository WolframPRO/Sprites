//
//  GameViewController.swift
//  Sprites
//
//  Created by Вова Петров on 03.10.2019.
//  Copyright © 2019 Вова Петров. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	@IBOutlet weak var sceneView: SKView!
	@IBOutlet weak var controlContentView: UIView!
	@IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var selectedPointLabel: UILabel!
    @IBOutlet weak var lineDefLabel: UILabel!
    
	var scene: GameScene!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		// Load the SKScene from 'GameScene.sks'
		if let scene = GameScene(fileNamed: "GameScene") {
			// Set the scale mode to scale to fit the window
			scene.scaleMode = .aspectFill
			
			// Present the scene
			sceneView.presentScene(scene)
			sceneView.isMultipleTouchEnabled = true
			self.scene = scene
            self.scene.afterInit()
		}
		
		sceneView.ignoresSiblingOrder = true
		
		sceneView.showsFPS = true
		sceneView.showsNodeCount = true
		
		controlContentView.layer.shadowColor = UIColor.gray.cgColor
		controlContentView.layer.shadowRadius = 4
		controlContentView.layer.shadowOpacity = 0.6
		controlContentView.layer.shadowOffset = .zero
		controlContentView.layer.cornerRadius = 30
		visualEffectView.layer.cornerRadius = 30
		visualEffectView.layer.masksToBounds = true
		visualEffectView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "selectedPoint"), object: nil, queue: .main) { (notification) in
            self.selectedPointLabel.text = "Выбрана точка: x:\(Int(notification.userInfo!["x"]! as! CGFloat)) y:\(Int(notification.userInfo!["y"]! as! CGFloat))"
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fx_line"), object: nil, queue: .main) { (notification) in
            self.lineDefLabel.text = "Уравнение прямой: \(notification.userInfo!["string"]! as! String)"
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
	@IBAction func removeAction(_ sender: Any) {
		if !scene.removeLine() {
			let alert = UIAlertController(title: "Так низя", message: "Выберите фигуру для удаления", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Понятно, выберу", style: .default))
			self.present(alert, animated: true)
		}
	}
	
	@IBAction func addAction(_ sender: Any) {
		scene.addLine()
	}
    
    @IBAction func axisButtonAction(_ sender: Any) {
        scene.setAxis(hidden: !scene.axisNode.isHidden)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
