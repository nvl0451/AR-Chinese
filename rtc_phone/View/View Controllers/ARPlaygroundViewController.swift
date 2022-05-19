//
//  ViewController.swift
//  rtc_place
//
//  Created by Андрей Королев on 12.05.2022.
//

import UIKit
import RealityKit
import TextEntity
import FocusEntity

class ARPlaygroundViewController: UIViewController {
    
    
    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var playGameButton: UIButton!
    @IBOutlet weak var winloseImageView: UIImageView!
    @IBOutlet weak var socialCreditLabel: UILabel!
    
    var focusEntity: FocusEntity?
    var sphere: ModelEntity?
    
    var stringsToPlace: [String] = []
    var translations: [Int: String] = [:]
    
    var colors: [UIColor] = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemCyan, UIColor.systemCyan, UIColor.systemPurple]
    
    var currentlyPlacing: Int = 0
    var currentlyFinding: Int = 0
    var placingMode: Bool = true
    var playingGame: Bool = false
    var showingScore: Bool = false
    
    var socialCreditScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        focusEntity = FocusEntity(on: self.arView, focus: .classic)
        focusEntity?.name = "focus"
        messageLabel.text = "Tap anywhere to place \(stringsToPlace[0]) - \(translations[0]!)"
        playGameButton.isHidden = true
        winloseImageView.isHidden = true
        socialCreditLabel.isHidden = true
        
        //add crosshair
        let mesh01 = MeshResource.generateSphere(radius: 0.001)
        sphere = ModelEntity(mesh: mesh01)
        let sphereMaterial = SimpleMaterial(color: .black, roughness: 0, isMetallic: false)
        sphere?.model?.materials = [sphereMaterial]
        sphere?.transform.translation.z = -0.15
        let cameraAnchor = AnchorEntity(.camera)
        sphere?.setParent(cameraAnchor)
        arView.scene.addAnchor(cameraAnchor)
        sphere?.isEnabled = false
        sphere?.name = "sphere"
        cameraAnchor.name = "camera"
        
        //arView.scene.anchors.
    }
    
    func newGameCycle() {
        placingMode = false
        showingScore = false
        socialCreditLabel.isHidden = true
        winloseImageView.isHidden = true
        //generate number
        let intMin = 0
        let intMax = stringsToPlace.count
        let rand = Int.random(in: intMin..<intMax)
        currentlyFinding = rand
        messageLabel.text = "Tap anywhere when text that means \(translations[currentlyFinding]!) is in crosshairs!"
        playingGame = true
    }
    
    @IBAction func playGameTapped(_ sender: Any) {
        playGameButton.isHidden = true
        newGameCycle()
    }
    
    func showScore(won: Bool) {
        playingGame = false
        showingScore = true
        socialCreditLabel.isHidden = false
        winloseImageView.isHidden = false
        if won {
            socialCreditScore += 15
            messageLabel.text = "Game won! Tap anywhere to play again"
            winloseImageView.image = UIImage(named: "socialCreditUp")
        } else {
            socialCreditScore -= 30
            messageLabel.text = "Game lost! Tap anywhere to play again"
            winloseImageView.image = UIImage(named: "socialCreditDown")
        }
        
        //update scs text and color
        socialCreditLabel.text = "Social Credit Score: \(socialCreditScore)"
        if socialCreditScore > 0 {
            socialCreditLabel.textColor = UIColor.systemGreen
        } else if socialCreditScore < 0 {
            socialCreditLabel.textColor = UIColor.systemRed
        } else {
            socialCreditLabel.textColor = UIColor.white
        }
    }
    
    func mixPostitions() {
        //let myAnchor = AnchorEntity(plane: .any)
        var positions: [SIMD3<Float>] = []
        var children: [Entity] = []
        for anchor in arView.scene.anchors {
            if anchor.name == "text" {
                print(anchor.name)
                positions.append(anchor.position)
                for child in anchor.children {
                    child.removeFromParent()
                    children.append(child)
                }
            }
            
        }
        
        positions = positions.shuffled()
        
        var newChildren = children
        while newChildren == children {
            newChildren = children.shuffled()
        }
        
        var currentAnchor: Int = 0
        for anchor in arView.scene.anchors {
            if anchor.name == "text" {
                //anchor.position = positions[currentAnchor]
                let material = SimpleMaterial(color: colors.randomElement()!,
                                              roughness: 0, // Surface roughness
                                              isMetallic: true)
                let child = newChildren[currentAnchor] as! ModelEntity
                child.model?.materials = [material]
                anchor.addChild(child)
                currentAnchor += 1
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if placingMode {
            let myAnchor = AnchorEntity(plane: .any)
            myAnchor.name = "text"
            let newText = TextEntity()
            let myText = ModelEntity(mesh: .generateText(stringsToPlace[currentlyPlacing], extrusionDepth: 0.03, font: .systemFont(ofSize: 0.1, weight: .bold), containerFrame: CGRect.zero, alignment: .center, lineBreakMode: .byCharWrapping))
            let material = SimpleMaterial(color: colors.randomElement()!,
                                          roughness: 0, // Surface roughness
                                          isMetallic: true)
            myText.model?.materials = [material]
            myText.generateCollisionShapes(recursive: true)
            myText.name = translations[currentlyPlacing]!
            newText.text = stringsToPlace[currentlyPlacing]
            newText.color = colors.randomElement()!
            myAnchor.addChild(myText)
            arView.scene.anchors.append(myAnchor)
            currentlyPlacing += 1
            
            if (currentlyPlacing == stringsToPlace.count) {
                focusEntity?.isEnabled = false
                placingMode = false
                messageLabel.text = "Placed everything. Tap Play Game to start playing"
                playGameButton.isHidden = false
                sphere?.isEnabled = true
            } else {
                messageLabel.text = "Tap anywhere to place \(stringsToPlace[currentlyPlacing]) - \(translations[currentlyPlacing]!)"
            }
        } else if playingGame {
            let touch = arView.center
            let results: [CollisionCastHit] = arView.hitTest(touch)
                    
            if let result: CollisionCastHit = results.first {
                if result.entity.name == translations[currentlyFinding]! && sphere?.isAnchored == true {
                    print("Right")
                    showScore(won: true)
                } else {
                    print("Wrong")
                    showScore(won: false)
                }
            }
        } else if showingScore {
            mixPostitions()
            newGameCycle()
        }
    }
}
