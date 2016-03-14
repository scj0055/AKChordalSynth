//
//  File.swift
//  FinalProject
//
//  Created by Samuel Johnson on 3/13/16.
//  Copyright © 2016 Samuel Johnson. All rights reserved.
//

import Foundation

class ChordCalculator {
    
    var currentChord: Int
    var currentType: String
    var currentOctave: Int
    
    var note1: Int
    var note2: Int
    var note3: Int
    
    // for the initializer, we can set these defaults as so - they will be immediately changed as soon as one chord is pressed.
    
    init() {
        self.currentChord = 1
        self.currentType = "major"
        self.currentOctave = 3
        
        self.note1 = 84
        self.note2 = 88
        self.note3 = 91
    }
    
    // calculate the chord based on the current class variables
    
    
    
}
