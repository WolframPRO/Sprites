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
    @IBOutlet weak var lockSwitch: UISwitch!
    
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
        
        Radio.Subscribe.selectedPoint { (text) in
            self.selectedPointLabel.text = text
        }
        
        Radio.Subscribe.fxLine { (text) in
            self.lineDefLabel.text = text
        }
        
//        Radio.Subscribe.nodeHaveParent { (have) in
//            self.lockSwitch.isOn = have
//            self.groupSwitchChanged(self.lockSwitch)
//        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
	@IBAction func removeAction(_ sender: Any) {
		if !scene.removeNode() {
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
    
    @IBAction func groupSwitchChanged(_ sender: UISwitch) {
        State.isGroupState = sender.isOn
    }
    
    @IBAction func ungroup(_ sender: Any) {
        scene.ungroup()
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
