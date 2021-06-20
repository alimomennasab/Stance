//
//  File.swift
//  NeckStretch
//
//  Created by xavier chia on 20/6/21.
//

import UIKit
import AVFoundation

struct Sounds {
    
    var startSound: AVAudioPlayer?
    var turnLeftSound: AVAudioPlayer?
    var turnRightSound: AVAudioPlayer?
    var lookUpSound: AVAudioPlayer?
    var lookDownSound: AVAudioPlayer?
    var tiltLeftSound: AVAudioPlayer?
    var tiltRightSound: AVAudioPlayer?
    var chinTuckSound: AVAudioPlayer?
    var smileSound: AVAudioPlayer?
    
    mutating func playStart() {
        let path = Bundle.main.path(forResource: "wink", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            startSound = try AVAudioPlayer(contentsOf: url)
            startSound?.play()
        } catch {
        }
    }
    
    mutating func turnLeft() {
        let path = Bundle.main.path(forResource: "turnLeft", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            turnLeftSound = try AVAudioPlayer(contentsOf: url)
            turnLeftSound?.play()
        } catch {
        }
    }
    
    mutating func turnRight() {
        let path = Bundle.main.path(forResource: "turnRight", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            turnRightSound = try AVAudioPlayer(contentsOf: url)
            turnRightSound?.play()
        } catch {
        }
    }
    
    mutating func lookUp() {
        let path = Bundle.main.path(forResource: "lookUp", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            lookUpSound = try AVAudioPlayer(contentsOf: url)
            lookUpSound?.play()
        } catch {
        }
    }
    
    mutating func lookDown() {
        let path = Bundle.main.path(forResource: "lookDown", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            lookDownSound = try AVAudioPlayer(contentsOf: url)
            lookDownSound?.play()
        } catch {
        }
    }
    
    mutating func tiltLeft() {
        let path = Bundle.main.path(forResource: "tiltLeft", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            tiltLeftSound = try AVAudioPlayer(contentsOf: url)
            tiltLeftSound?.play()
        } catch {
        }
    }
    
    mutating func tiltRight() {
        let path = Bundle.main.path(forResource: "tiltRight", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            tiltRightSound = try AVAudioPlayer(contentsOf: url)
            tiltRightSound?.play()
        } catch {
        }
    }
    
    mutating func chinTuck() {
        let path = Bundle.main.path(forResource: "chinTuck", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            chinTuckSound = try AVAudioPlayer(contentsOf: url)
            chinTuckSound?.play()
        } catch {
        }
    }
    
    mutating func smile() {
        let path = Bundle.main.path(forResource: "smile", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            smileSound = try AVAudioPlayer(contentsOf: url)
            smileSound?.play()
        } catch {
        }
    }
}
