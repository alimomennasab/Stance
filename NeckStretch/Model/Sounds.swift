//
//  File.swift
//  NeckStretch
//
//  Created by xavier chia on 20/6/21.
//

import UIKit
import AVFoundation

struct Sounds {
    
    var sound: AVAudioPlayer?
    
    mutating func playSound(name: String) {
        let path = Bundle.main.path(forResource: name, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound?.play()
        } catch {
        }
    }
    
    mutating func playNumber(number: Int) {
        let numberString = String(number)
        playSound(name: numberString)
    }
}
