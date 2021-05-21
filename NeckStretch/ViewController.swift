//
//  ViewController.swift
//  roboAnimoji
//
//  Created by xavier chia on 7/5/21.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet weak var arView: ARView!
    var startAnchor: NeckStretch.Start!
    var faceLeftAnchor: NeckStretch.FaceLeft!
    var faceRightAnchor: NeckStretch.FaceRight!
    var lookUpAnchor: NeckStretch.LookUp!
    var lookDownAnchor: NeckStretch.LookDown!
    var tiltLeftAnchor: NeckStretch.TiltLeft!
    var tiltRightAnchor: NeckStretch.TiltRight!
    var chinTuckAnchor: NeckStretch.ChinTuck!
    var completeAnchor: NeckStretch.Complete!
    var state = NeckStates.start
    
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var yawLabel: UILabel!
    @IBOutlet weak var rollLabel: UILabel!
    var downPitch: Float = 0
    var upPitch: Float = 0
    var rightYaw: Float = 0
    var leftYaw: Float = 0
    var rightRoll: Float = 0
    var leftRoll: Float = 0
    var chinTuck: Float = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config)
        arView.session.delegate = self
        
        startAnchor = try! NeckStretch.loadStart()
        arView.scene.anchors.append(startAnchor)
        
    }
    
    enum NeckStates {
        static let start = "start"
        static let faceLeft = "faceLeft"
        static let faceRight = "faceRight"
        static let lookUp = "lookUp"
        static let lookDown = "lookDown"
        static let tiltLeft = "tiltLeft"
        static let tiltRight = "tiltRight"
        static let chinTuck = "chinTuck"
        static let complete = "complete"
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
            let blendShapes = faceAnchor.blendShapes
            guard let leftEyeValue = blendShapes[.eyeBlinkLeft],
                  let rightEyeValue = blendShapes[.eyeBlinkRight] else { return }
            
            if (Double(truncating: leftEyeValue) > 0.5 && Double(truncating: rightEyeValue) < 0.5) ||
                (Double(truncating: leftEyeValue) < 0.5 && Double(truncating: rightEyeValue) > 0.5) {
                arView.scene.removeAnchor(startAnchor)
                faceLeftAnchor = try! NeckStretch.loadFaceLeft()
                arView.scene.anchors.append(faceLeftAnchor)
                resetAngles()
                state = NeckStates.faceLeft
            }
        }
        
        if state == NeckStates.faceLeft {

            if leftYaw < -0.25 {
                arView.scene.removeAnchor(faceLeftAnchor)
                faceRightAnchor = try! NeckStretch.loadFaceRight()
                arView.scene.anchors.append(faceRightAnchor)
                resetAngles()
                state = NeckStates.faceRight
            }
        }
        
        if state == NeckStates.faceRight {
            if rightYaw > 0.25 {
                arView.scene.removeAnchor(faceRightAnchor)
                lookUpAnchor = try! NeckStretch.loadLookUp()
                arView.scene.anchors.append(lookUpAnchor)
                resetAngles()
                state = NeckStates.lookUp
            }
        }
        
        if state == NeckStates.lookUp {
            if upPitch < -0.25 {
                arView.scene.removeAnchor(lookUpAnchor)
                lookDownAnchor = try! NeckStretch.loadLookDown()
                arView.scene.anchors.append(lookDownAnchor)
                resetAngles()
                state = NeckStates.lookDown
            }
        }
        
        if state == NeckStates.lookDown {
            if downPitch > 0.25 {
                arView.scene.removeAnchor(lookDownAnchor)
                tiltLeftAnchor = try! NeckStretch.loadTiltLeft()
                arView.scene.anchors.append(tiltLeftAnchor)
                resetAngles()
                state = NeckStates.tiltLeft
            }
        }
        
        if state == NeckStates.tiltLeft {
            if leftRoll < -0.25 {
                arView.scene.removeAnchor(tiltLeftAnchor)
                tiltRightAnchor = try! NeckStretch.loadTiltRight()
                arView.scene.anchors.append(tiltRightAnchor)
                resetAngles()
                state = NeckStates.tiltRight
            }
        }
        
        if state == NeckStates.tiltRight {
            if rightRoll > 0.25 {
                arView.scene.removeAnchor(tiltRightAnchor)
                chinTuckAnchor = try! NeckStretch.loadChinTuck()
                arView.scene.anchors.append(chinTuckAnchor)
                resetAngles()
                state = NeckStates.chinTuck
                chinTuck = faceAnchor.transform.columns.3[2]
            }
        }
                
        if state == NeckStates.chinTuck {
            let currentChinTuck = faceAnchor.transform.columns.3[2]
            if chinTuck - currentChinTuck > 0.02 {
                arView.scene.removeAnchor(chinTuckAnchor)
                completeAnchor = try! NeckStretch.loadComplete()
                arView.scene.anchors.append(completeAnchor)
                resetAngles()
                state = NeckStates.complete
            }
        }
        
        if state == NeckStates.complete {
            let blendShapes = faceAnchor.blendShapes
            guard let mouthSmileLeft = blendShapes[.mouthSmileLeft],
                  let mouthSmileRight = blendShapes[.mouthSmileRight] else { return }
            
            if (Double(truncating: mouthSmileLeft) > 0.5 && Double(truncating: mouthSmileRight) > 0.5) {
                arView.scene.removeAnchor(completeAnchor)
                startAnchor = try! NeckStretch.loadStart()
                arView.scene.anchors.append(startAnchor)
                resetAngles()
                state = NeckStates.start
            }
        }
        
    }
    
    func updateLabels(faceAnchor: ARFaceAnchor) {
        
        let pitch = Float(round(1000*(faceAnchor.transform.eulerAnglez.x))/1000)
        
        if pitch > downPitch {
            downPitch = pitch
        }
        
        if pitch < upPitch {
            upPitch = pitch
        }
        
        let yaw = Float(round(1000*(faceAnchor.transform.eulerAnglez.y))/1000)
        
        if yaw > rightYaw {
            rightYaw = yaw
        }
        
        if yaw < leftYaw {
            leftYaw = yaw
        }
        
        let roll = -Float(round(1000*(faceAnchor.transform.eulerAnglez.z))/1000)
        
        if roll > rightRoll {
            rightRoll = roll
        }
        
        if roll < leftRoll {
            leftRoll = roll
        }
                
        pitchLabel.text = "Pitch Up: \(upPitch) Down: \(downPitch) "
        
        yawLabel.text = "Yaw Left: \(leftYaw) Right: \(rightYaw)"
        
        rollLabel.text = "Roll Left: \(rightRoll) Right: \(leftRoll)"
    }
    
    func resetAngles() {
        upPitch = 0
        downPitch = 0
        leftYaw = 0
        rightYaw = 0
        leftRoll = 0
        rightRoll = 0
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

