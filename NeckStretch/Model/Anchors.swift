//
//  Anchors.swift
//  NeckStretch
//
//  Created by xavier chia on 23/6/21.
//

import UIKit
import RealityKit
import ARKit

struct Anchors {
    var startAnchor: NeckStretch.Start!
    var initialBufferAnchor: NeckStretch.InitialBuffer!
    var faceLeftAnchor: NeckStretch.FaceLeft!
    var faceRightAnchor: NeckStretch.FaceRight!
    var lookUpAnchor: NeckStretch.LookUp!
    var lookDownAnchor: NeckStretch.LookDown!
    var tiltLeftAnchor: NeckStretch.TiltLeft!
    var tiltRightAnchor: NeckStretch.TiltRight!
    var chinTuckAnchor: NeckStretch.ChinTuck!
    
    var complete1Anchor: NeckStretch.Complete1!
    var complete2Anchor: NeckStretch.Complete2!
    var complete3Anchor: NeckStretch.Complete3!
    
    mutating func getStartAnchor() -> NeckStretch.Start {
        startAnchor = try! NeckStretch.loadStart()
        return startAnchor
    }
    
    mutating func getInitialBufferAnchor() -> NeckStretch.InitialBuffer {
        initialBufferAnchor = try! NeckStretch.loadInitialBuffer()
        return initialBufferAnchor
    }
    
    mutating func getFaceLeftAnchor() -> NeckStretch.FaceLeft {
        faceLeftAnchor = try! NeckStretch.loadFaceLeft()
        return faceLeftAnchor
    }
    
    mutating func getFaceRightAnchor() -> NeckStretch.FaceRight {
        faceRightAnchor = try! NeckStretch.loadFaceRight()
        return faceRightAnchor
    }
    
    mutating func getLookUpAnchor() -> NeckStretch.LookUp {
        lookUpAnchor = try! NeckStretch.loadLookUp()
        return lookUpAnchor
    }
    
    mutating func getLookDownAnchor() -> NeckStretch.LookDown {
        lookDownAnchor = try! NeckStretch.loadLookDown()
        return lookDownAnchor
    }
    
    mutating func getTiltLeftAnchor() -> NeckStretch.TiltLeft {
        tiltLeftAnchor = try! NeckStretch.loadTiltLeft()
        return tiltLeftAnchor
    }
    
    mutating func getTiltRightAnchor() -> NeckStretch.TiltRight {
        tiltRightAnchor = try! NeckStretch.loadTiltRight()
        return tiltRightAnchor
    }
    
    mutating func getChinTuckAnchor() -> NeckStretch.ChinTuck {
        chinTuckAnchor = try! NeckStretch.loadChinTuck()
        return chinTuckAnchor
    }
    
    mutating func getComplete1Anchor() -> NeckStretch.Complete1 {
        complete1Anchor = try! NeckStretch.loadComplete1()
        return complete1Anchor
    }
    
    mutating func getComplete2Anchor() -> NeckStretch.Complete2 {
        complete2Anchor = try! NeckStretch.loadComplete2()
        return complete2Anchor
    }
    
    mutating func getComplete3Anchor() -> NeckStretch.Complete3 {
        complete3Anchor = try! NeckStretch.loadComplete3()
        return complete3Anchor
    }
}
