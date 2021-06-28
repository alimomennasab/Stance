//
//  Enums.swift
//  NeckStretch
//
//  Created by xavier chia on 4/6/21.
//

import UIKit

enum Segues {
    static let showNoTrueDepth = "showNoTrueDepth"
}

enum Shares {
    static let appLink = "https://testflight.apple.com/join/fHOVyPP1"
}

enum CompleteAnchors {
    static let complete1Anchor = "complete1Anchor"
    static let complete2Anchor = "complete2Anchor"
    static let complete3Anchor = "complete3Anchor"
}

enum NeckStates {
    static let start = "start"
    static let initialBuffer = "initialBuffer"
    static let turnLeft = "turnLeft"
    static let turnRight = "turnRight"
    static let lookUp = "lookUp"
    static let lookDown = "lookDown"
    static let tiltLeft = "tiltLeft"
    static let tiltRight = "tiltRight"
    static let chinTuck = "chinTuck"
    static let smile = "smile"
}

enum Times {
    static let shortDelay = 0.2
    static let delay = 1.0
    static let smileHold = 3.0
}
