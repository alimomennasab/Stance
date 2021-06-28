//
//  ViewController.swift
//  roboAnimoji
//
//  Created by xavier chia on 7/5/21.
//

import Firebase

import UIKit
import RealityKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet weak var arView: ARView!
    
    var anchors = Anchors()
    var state = NeckStates.start
    var inDelay = false
    var numOfRounds = 0
    var initialTuck: Float = 0
    var completeAnchor = ""
    var sounds = Sounds()
    let hapticGenerator = UINotificationFeedbackGenerator()
    
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var yawLabel: UILabel!
    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var tuckLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    let config = ARFaceTrackingConfiguration()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // start ar view
        if ARFaceTrackingConfiguration.isSupported == true {
            arView.session.run(config)
            arView.session.delegate = self
            
            arView.scene.anchors.append(anchors.getStartAnchor())
            sounds.playSound(name: NeckStates.start)
            countLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // go to 'noTrueDepth' VC if not available
        if ARFaceTrackingConfiguration.isSupported == false {
            performSegue(withIdentifier: Segues.showNoTrueDepth, sender: self)
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        var faceAnchor: ARFaceAnchor!
        
        for i in anchors {
            if let anchor = i as? ARFaceAnchor {
                faceAnchor = anchor
            }
        }
        
        updateLabels(faceAnchor: faceAnchor)
        
        if state == NeckStates.start {
            numOfRounds = 0
            
            let blendShapes = faceAnchor.blendShapes
            guard let leftEyeValue = blendShapes[.eyeBlinkLeft],
                  let rightEyeValue = blendShapes[.eyeBlinkRight] else { return }
            
            if (Double(truncating: leftEyeValue) > 0.5 && Double(truncating: rightEyeValue) < 0.5) ||
                (Double(truncating: leftEyeValue) < 0.5 && Double(truncating: rightEyeValue) > 0.5) {
                arView.scene.removeAnchor(self.anchors.startAnchor)
                
                // reset tracking is needed in case user was facing camera at a weird angle when opening the app
                arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
                
                // initial buffer is needed as yaw can be an erratic number like -0.3 when tracking is reset, this causes faceLeft scene to be skipped
                arView.scene.anchors.append(self.anchors.getInitialBufferAnchor())
                state = NeckStates.initialBuffer
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.shortDelay) {
                    self.arView.scene.removeAnchor(self.anchors.initialBufferAnchor)
                    self.arView.scene.anchors.append(self.anchors.getFaceLeftAnchor())
                    self.state = NeckStates.turnLeft
                    self.sounds.playSound(name: NeckStates.turnLeft)
                    self.hapticGenerator.notificationOccurred(.success)
                }
            }
        }
        
        if state == NeckStates.turnLeft && inDelay == false {
            let currentYaw = Float(round(1000*(faceAnchor.transform.eulerAnglez.y))/1000)
            
            if currentYaw < -0.4 {
                inDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.delay) {
                    self.arView.scene.removeAnchor(self.anchors.faceLeftAnchor)
                    self.arView.scene.anchors.append(self.anchors.getFaceRightAnchor())
                    self.state = NeckStates.turnRight
                    
                    self.sounds.playSound(name: NeckStates.turnRight)
                    self.hapticGenerator.notificationOccurred(.success)
                    self.inDelay = false
                    
                }
                
            }
        }
        
        if state == NeckStates.turnRight && inDelay == false {
            let currentYaw = Float(round(1000*(faceAnchor.transform.eulerAnglez.y))/1000)
            
            if currentYaw > 0.4 {
                inDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.delay) {
                    self.arView.scene.removeAnchor(self.anchors.faceRightAnchor)
                    self.arView.scene.anchors.append(self.anchors.getLookUpAnchor())
                    self.state = NeckStates.lookUp
                    
                    self.sounds.playSound(name: NeckStates.lookUp)
                    self.hapticGenerator.notificationOccurred(.success)
                    self.inDelay = false
                }
            }
        }
        
        if state == NeckStates.lookUp && inDelay == false {
            let currentPitch = Float(round(1000*(faceAnchor.transform.eulerAnglez.x))/1000)
            
            if currentPitch < -0.4 {
                inDelay = true
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.delay) {
                    self.arView.scene.removeAnchor(self.anchors.lookUpAnchor)
                    self.arView.scene.anchors.append(self.anchors.getLookDownAnchor())
                    self.state = NeckStates.lookDown
                    
                    self.sounds.playSound(name: NeckStates.lookDown)
                    self.hapticGenerator.notificationOccurred(.success)
                    self.inDelay = false
                }
            }
        }
        
        if state == NeckStates.lookDown && inDelay == false {
            let currentPitch = Float(round(1000*(faceAnchor.transform.eulerAnglez.x))/1000)
            
            if currentPitch > 0.4 {
                inDelay = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.delay) {
                    self.arView.scene.removeAnchor(self.anchors.lookDownAnchor)
                    self.arView.scene.anchors.append(self.anchors.getTiltLeftAnchor())
                    self.state = NeckStates.tiltLeft
                    
                    self.sounds.playSound(name: NeckStates.tiltLeft)
                    self.hapticGenerator.notificationOccurred(.success)
                    self.inDelay = false
                }
            }
        }
        
        if state == NeckStates.tiltLeft && inDelay == false {
            let currentRoll = -Float(round(1000*(faceAnchor.transform.eulerAnglez.z))/1000)
            
            if currentRoll < -0.4 {
                inDelay = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.delay) {
                    self.arView.scene.removeAnchor(self.anchors.tiltLeftAnchor)
                    self.arView.scene.anchors.append(self.anchors.getTiltRightAnchor())
                    self.state = NeckStates.tiltRight
                    
                    self.sounds.playSound(name: NeckStates.tiltRight)
                    self.hapticGenerator.notificationOccurred(.success)
                    self.inDelay = false
                }
            }
        }
        
        if state == NeckStates.tiltRight && inDelay == false {
            let currentRoll = -Float(round(1000*(faceAnchor.transform.eulerAnglez.z))/1000)
            
            if currentRoll > 0.4 {
                inDelay = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.delay) {
                    
                    self.arView.scene.removeAnchor(self.anchors.tiltRightAnchor)
                    self.arView.scene.anchors.append(self.anchors.getChinTuckAnchor())
                    self.state = NeckStates.chinTuck
                    self.initialTuck = faceAnchor.transform.columns.3[2]
                    
                    self.sounds.playSound(name: NeckStates.chinTuck)
                    self.hapticGenerator.notificationOccurred(.success)
                    self.inDelay = false
                }
            }
        }
        
        if state == NeckStates.chinTuck && inDelay == false {
            let currentTuck = faceAnchor.transform.columns.3[2]
            if -initialTuck + currentTuck < -0.02 {
                inDelay = true
                
                numOfRounds += 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.delay) {
                    if self.numOfRounds == 2 {
                        self.arView.scene.removeAnchor(self.anchors.chinTuckAnchor)
                        self.addCompleteAnchor()
                        self.state = NeckStates.smile
                        
                        self.sounds.playSound(name: NeckStates.smile)
                        self.hapticGenerator.notificationOccurred(.success)
                    }
                    
                    else {
                        self.arView.scene.removeAnchor(self.anchors.chinTuckAnchor)
                        self.arView.scene.anchors.append(self.anchors.getFaceLeftAnchor())
                        self.state = NeckStates.turnLeft
                        self.sounds.playSound(name: NeckStates.turnLeft)
                        self.hapticGenerator.notificationOccurred(.success)
                    }
                    
                    self.inDelay = false
                }
            }
        }
        
        if state == NeckStates.smile {
            let blendShapes = faceAnchor.blendShapes
            guard let mouthSmileLeft = blendShapes[.mouthSmileLeft],
                  let mouthSmileRight = blendShapes[.mouthSmileRight] else { return }
            
            if (Double(truncating: mouthSmileLeft) > 0.5 && Double(truncating: mouthSmileRight) > 0.5) && inDelay == false {
                
                inDelay = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Times.delay) {
                    
                    var runCount = Int(Times.smileHold)
                    
                    self.countLabel.isHidden = false
                    self.countLabel.text = String(runCount)
                    self.sounds.playNumber(number: runCount)
                    
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        runCount -= 1
                        self.countLabel.text = String(runCount)
                        self.sounds.playNumber(number: runCount)
                        
                        if runCount == 0 {
                            timer.invalidate()
                            self.countLabel.text = ""
                            self.countLabel.isHidden = true
                            
                            self.removeCompleteAnchor()
                            self.arView.scene.anchors.append(self.anchors.getStartAnchor())
                            self.state = NeckStates.start
                            
                            self.sounds.playSound(name: NeckStates.start)
                            self.hapticGenerator.notificationOccurred(.success)
                            self.inDelay = false
                            
                            // request for notifications
                            let localNotifications = LocalNotifications()
                            localNotifications.requestLocalNotifications()
                            
                            // remove notification badge after complete
                            UIApplication.shared.applicationIconBadgeNumber = 0
                            
                            Analytics.logEvent("stretch_complete", parameters: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    func removeCompleteAnchor() {
        if completeAnchor == CompleteAnchors.complete1Anchor {
            arView.scene.removeAnchor(anchors.complete1Anchor)
        }
        
        else if completeAnchor == CompleteAnchors.complete2Anchor {
            arView.scene.removeAnchor(anchors.complete2Anchor)
        }
        
        else {
            arView.scene.removeAnchor(anchors.complete3Anchor)
        }
    }
    
    func addCompleteAnchor() {
        let randomInt = Int.random(in: 1...3)
        
        if randomInt == 1 {
            arView.scene.anchors.append(anchors.getComplete1Anchor())
            completeAnchor = CompleteAnchors.complete1Anchor
        }
        
        else if randomInt == 2 {
            arView.scene.anchors.append(anchors.getComplete2Anchor())
            completeAnchor = CompleteAnchors.complete2Anchor
        }
        
        else {
            arView.scene.anchors.append(anchors.getComplete3Anchor())
            completeAnchor = CompleteAnchors.complete3Anchor
        }
        
    }
    
    func updateLabels(faceAnchor: ARFaceAnchor) {
        
        let tuck = Float(round(1000*(faceAnchor.transform.columns.3[2]))/1000)
        
        let pitch = Float(round(1000*(faceAnchor.transform.eulerAnglez.x))/1000)
        
        let yaw = Float(round(1000*(faceAnchor.transform.eulerAnglez.y))/1000)
        
        let roll = -Float(round(1000*(faceAnchor.transform.eulerAnglez.z))/1000)
        
        tuckLabel.text = "Tuck: \(tuck)"
        
        pitchLabel.text = "Pitch: \(pitch) "
        
        yawLabel.text = "Yaw: \(yaw)"
        
        rollLabel.text = "Roll: \(roll)"
    }
    
}


extension simd_float4x4 {
    var eulerAnglez: simd_float3 {
        simd_float3(
            x: asin(-self[2][1]),
            y: atan2(self[2][0], self[2][2]),
            z: atan2(self[0][1], self[1][1])
        )
    }
}

