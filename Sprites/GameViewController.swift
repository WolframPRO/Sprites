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
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sceneView: SKView!
	@IBOutlet weak var controlContentView: UIView!
	@IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var selectedPointLabel: UILabel!
    @IBOutlet weak var lineDefLabel: UILabel!
    @IBOutlet weak var lockSwitch: UISwitch!
    @IBOutlet weak var zField: UITextField!
    @IBOutlet weak var selectedPointSwitcher: UISegmentedControl!
    @IBOutlet weak var morfingPicker: UIPickerView!
    
	var scene: GameScene!
    var isMorfingMode: Bool = false {
        didSet {
            contentHeight.constant = isMorfingMode ? 766 : 350
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            StateMachine.state = isMorfingMode ? .morfing : .normal
        }
    }
	
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
        
        Radio.Subscribe.selectedPoint {[weak self] (arg) in
            
            let (first, end) = arg
            self?.fillSelectedPointLabel(start: first, end: end)
        }
        
        Radio.Subscribe.fxLine { (text) in
            self.lineDefLabel.text = text
        }
    }
    
    func fillSelectedPointLabel(start: Point3D, end: Point3D) {
        let point = selectedPointSwitcher.selectedSegmentIndex == 0 ? start : end
        self.selectedPointLabel.text = "x: \(floor(point.x)) y: \(floor(point.y))"
        self.zField.text = "\(floor(point.z))"
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
        StateMachine.state = sender.isOn ? .group : .normal
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
    
    @IBAction func zValueHasChanged(_ sender: Any) {
        guard let text = zField.text,
            let floatValue = Float(text) else { return }
        
        let value = CGFloat(floatValue)
        scene.zChanged(to: value, isLast: selectedPointSwitcher.selectedSegmentIndex == 1)
    }
    @IBAction func selectPoint(_ sender: Any) {
        pointChanged()
    }
    
    func pointChanged() {
        scene.updateRadioState()
    }
    
    @IBAction func morphAction(_ sender: UIButton) {
       isMorfingMode = !isMorfingMode
        containerView.subviews.forEach {
            $0.alpha = isMorfingMode ? 0.5 : 1.0
            $0.isUserInteractionEnabled = !isMorfingMode
        }
        sender.alpha = 1.0
        sender.isUserInteractionEnabled = true
        morfingPicker.alpha = 1.0
        morfingPicker.isUserInteractionEnabled = true
    }
}


extension GameViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(row+1)"
    }
}

extension GameViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Radio.post(morfingValue: row+1)
    }
}
