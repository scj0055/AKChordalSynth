//
//  SynthViewController.swift
//  FinalProject
//
//  Created by Samuel Johnson on 3/7/16.
//  Copyright © 2016 Samuel Johnson. All rights reserved.
//

import UIKit
import AudioKit

class SynthViewController: UIViewController {
    
    //
    /*
    MARK: INSTANCE VARIABLES
    */
    //
    
    var sampler = AKSampler()
    var currentOctave = 5
    var currentPatch = "BELL"
    var majorOrMinorSeventh = "minor"
    
    var note1 = 1
    var note2 = 2
    var note3 = 3
    
    /*
    //
    
    MARK: OUTLET CONNECTIONS
    //
    */
    @IBOutlet weak var currentPatchName: UILabel!
    
    /*
    //
    MARK: LIFECYCLE
    //
    */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadPatch(currentPatch)
        
        // start AudioKit
        AudioKit.output = sampler
        AudioKit.start()
        
        print(NSBundle.mainBundle().resourcePath)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    //
    MARK: HELPER FUNCTIONS
    //
    */
    
    func loadPatch(patchToLoad: String) {
        sampler.loadWav(patchToLoad)
        self.currentPatch = patchToLoad
        self.currentPatchName.text = "Current Patch: \(patchToLoad)"
    }
    
    /*
    //
    MARK: SOUND CONTROL
    //
    */
    
    func playChord() {
        sampler.playNote(self.note1, velocity: 127, channel: 0)
        sampler.playNote(self.note2, velocity: 127, channel: 0)
        sampler.playNote(self.note3, velocity: 127, channel: 0)
    }
    
    func stopChord() {
        sampler.stopNote(self.note1, channel: 0)
        sampler.stopNote(self.note2, channel: 0)
        sampler.stopNote(self.note3, channel: 0)
    }
    
    // helper function - takes in the tag value of a button and calculates the chord value
    // then, plays the actual chord
    
    func prepareToPlayChord(senderTag: Int, playOrStop: String) {
        
        if senderTag < 200 {
            
            let chordToPlay = senderTag - 100
            calculateChord("major", currentChord: chordToPlay, currentOctave: self.currentOctave)
            
        } else if senderTag < 300 {
            
            let chordToPlay = senderTag - 200
            calculateChord("minor", currentChord: chordToPlay, currentOctave: self.currentOctave)
            
        } else if senderTag < 400 {
            
            let chordToPlay = senderTag - 300
            calculateChord("seventh", currentChord: chordToPlay, currentOctave: self.currentOctave)
        }
        
        // either choose to play or stop the chord here
        if playOrStop == "play" {
            playChord()
        } else {
            stopChord()
        }
        
    }
    
    func calculateChord(currentType: String, currentChord: Int, currentOctave: Int) {
        
        if currentType == "major" {
            switch currentChord {
                // c major
                // e.g. 24, 28, 31
            case 1:
                note1 = (currentOctave * 12)
                note2 = (currentOctave * 12 + 4)
                note3 = (currentOctave * 12 + 7)
            case 2:
                note1 = (currentOctave * 12) + 1
                note2 = (currentOctave * 12 + 4) + 1
                note3 = (currentOctave * 12 + 7) + 1
            case 3:
                note1 = (currentOctave * 12) + 2
                note2 = (currentOctave * 12 + 4) + 2
                note3 = (currentOctave * 12 + 7) + 2
            case 4:
                note1 = (currentOctave * 12) + 3
                note2 = (currentOctave * 12 + 4) + 3
                note3 = (currentOctave * 12 + 7) + 3
            case 5:
                note1 = (currentOctave * 12) + 4
                note2 = (currentOctave * 12 + 4) + 4
                note3 = (currentOctave * 12 + 7) + 4
            case 6:
                note1 = (currentOctave * 12) + 5
                note2 = (currentOctave * 12 + 4) + 5
                note3 = (currentOctave * 12 + 7) + 5
            case 7:
                note1 = (currentOctave * 12) + 6
                note2 = (currentOctave * 12 + 4) + 6
                note3 = (currentOctave * 12 + 7) + 6
            case 8:
                note1 = (currentOctave * 12) + 7
                note2 = (currentOctave * 12 + 4) + 7
                note3 = (currentOctave * 12 + 7) + 7
            case 9:
                note1 = (currentOctave * 12) + 8
                note2 = (currentOctave * 12 + 4) + 8
                note3 = (currentOctave * 12 + 7) + 8
            case 10:
                note1 = (currentOctave * 12) + 9
                note2 = (currentOctave * 12 + 4) + 9
                note3 = (currentOctave * 12 + 7) + 9
            case 11:
                note1 = (currentOctave * 12) + 10
                note2 = (currentOctave * 12 + 4) + 10
                note3 = (currentOctave * 12 + 7) + 10
            case 12:
                note1 = (currentOctave * 12) + 11
                note2 = (currentOctave * 12 + 4) + 11
                note3 = (currentOctave * 12 + 7) + 11
            default:
                note1 = (currentOctave * 12)
                note2 = (currentOctave * 12 + 4)
                note3 = (currentOctave * 12 + 7)
                
            }
        } else if currentType == "minor" {
            switch currentChord {
                // c major
                // e.g. 24, 28, 31
            case 1:
                note1 = (currentOctave * 12)
                note2 = (currentOctave * 12 + 3)
                note3 = (currentOctave * 12 + 7)
            case 2:
                note1 = (currentOctave * 12) + 1
                note2 = (currentOctave * 12 + 3) + 1
                note3 = (currentOctave * 12 + 7) + 1
            case 3:
                note1 = (currentOctave * 12) + 2
                note2 = (currentOctave * 12 + 3) + 2
                note3 = (currentOctave * 12 + 7) + 2
            case 4:
                note1 = (currentOctave * 12) + 3
                note2 = (currentOctave * 12 + 3) + 3
                note3 = (currentOctave * 12 + 7) + 3
            case 5:
                note1 = (currentOctave * 12) + 4
                note2 = (currentOctave * 12 + 3) + 4
                note3 = (currentOctave * 12 + 7) + 4
            case 6:
                note1 = (currentOctave * 12) + 5
                note2 = (currentOctave * 12 + 3) + 5
                note3 = (currentOctave * 12 + 7) + 5
            case 7:
                note1 = (currentOctave * 12) + 6
                note2 = (currentOctave * 12 + 3) + 6
                note3 = (currentOctave * 12 + 7) + 6
            case 8:
                note1 = (currentOctave * 12) + 7
                note2 = (currentOctave * 12 + 3) + 7
                note3 = (currentOctave * 12 + 7) + 7
            case 9:
                note1 = (currentOctave * 12) + 8
                note2 = (currentOctave * 12 + 3) + 8
                note3 = (currentOctave * 12 + 7) + 8
            case 10:
                note1 = (currentOctave * 12) + 9
                note2 = (currentOctave * 12 + 3) + 9
                note3 = (currentOctave * 12 + 7) + 9
            case 11:
                note1 = (currentOctave * 12) + 10
                note2 = (currentOctave * 12 + 3) + 10
                note3 = (currentOctave * 12 + 7) + 10
            case 12:
                note1 = (currentOctave * 12) + 11
                note2 = (currentOctave * 12 + 3) + 11
                note3 = (currentOctave * 12 + 7) + 11
            default:
                note1 = (currentOctave * 12)
                note2 = (currentOctave * 12 + 3)
                note3 = (currentOctave * 12 + 7)
            }
        }
        
        // else, we have a seventh chord
        
        else if currentType == "seventh" {
            
            // seventh chords can be either major or minor
            if self.majorOrMinorSeventh == "major" {
                
                switch currentChord {
                    // c major 7th
                    // e.g. 24, 28, 35
                case 1:
                    note1 = (currentOctave * 12)
                    note2 = (currentOctave * 12 + 4)
                    note3 = (currentOctave * 12 + 11)
                case 2:
                    note1 = (currentOctave * 12) + 1
                    note2 = (currentOctave * 12 + 4) + 1
                    note3 = (currentOctave * 12 + 11) + 1
                case 3:
                    note1 = (currentOctave * 12) + 2
                    note2 = (currentOctave * 12 + 4) + 2
                    note3 = (currentOctave * 12 + 11) + 2
                case 4:
                    note1 = (currentOctave * 12) + 3
                    note2 = (currentOctave * 12 + 4) + 3
                    note3 = (currentOctave * 12 + 11) + 3
                case 5:
                    note1 = (currentOctave * 12) + 4
                    note2 = (currentOctave * 12 + 4) + 4
                    note3 = (currentOctave * 12 + 11) + 4
                case 6:
                    note1 = (currentOctave * 12) + 5
                    note2 = (currentOctave * 12 + 4) + 5
                    note3 = (currentOctave * 12 + 11) + 5
                case 7:
                    note1 = (currentOctave * 12) + 6
                    note2 = (currentOctave * 12 + 4) + 6
                    note3 = (currentOctave * 12 + 11) + 6
                case 8:
                    note1 = (currentOctave * 12) + 7
                    note2 = (currentOctave * 12 + 4) + 7
                    note3 = (currentOctave * 12 + 11) + 7
                case 9:
                    note1 = (currentOctave * 12) + 8
                    note2 = (currentOctave * 12 + 4) + 8
                    note3 = (currentOctave * 12 + 11) + 8
                case 10:
                    note1 = (currentOctave * 12) + 9
                    note2 = (currentOctave * 12 + 4) + 9
                    note3 = (currentOctave * 12 + 11) + 9
                case 11:
                    note1 = (currentOctave * 12) + 10
                    note2 = (currentOctave * 12 + 4) + 10
                    note3 = (currentOctave * 12 + 11) + 10
                case 12:
                    note1 = (currentOctave * 12) + 11
                    note2 = (currentOctave * 12 + 4) + 11
                    note3 = (currentOctave * 12 + 11) + 11
                default:
                    note1 = (currentOctave * 12)
                    note2 = (currentOctave * 12 + 4)
                    note3 = (currentOctave * 12 + 11)
                }
                
            } else {
                
                switch currentChord {
                    // c major 7th
                    // e.g. 24, 28, 35
                case 1:
                    note1 = (currentOctave * 12)
                    note2 = (currentOctave * 12 + 3)
                    note3 = (currentOctave * 12 + 10)
                case 2:
                    note1 = (currentOctave * 12) + 1
                    note2 = (currentOctave * 12 + 3) + 1
                    note3 = (currentOctave * 12 + 10) + 1
                case 3:
                    note1 = (currentOctave * 12) + 2
                    note2 = (currentOctave * 12 + 3) + 2
                    note3 = (currentOctave * 12 + 10) + 2
                case 4:
                    note1 = (currentOctave * 12) + 3
                    note2 = (currentOctave * 12 + 3) + 3
                    note3 = (currentOctave * 12 + 10) + 3
                case 5:
                    note1 = (currentOctave * 12) + 4
                    note2 = (currentOctave * 12 + 3) + 4
                    note3 = (currentOctave * 12 + 10) + 4
                case 6:
                    note1 = (currentOctave * 12) + 5
                    note2 = (currentOctave * 12 + 3) + 5
                    note3 = (currentOctave * 12 + 10) + 5
                case 7:
                    note1 = (currentOctave * 12) + 6
                    note2 = (currentOctave * 12 + 3) + 6
                    note3 = (currentOctave * 12 + 10) + 6
                case 8:
                    note1 = (currentOctave * 12) + 7
                    note2 = (currentOctave * 12 + 3) + 7
                    note3 = (currentOctave * 12 + 10) + 7
                case 9:
                    note1 = (currentOctave * 12) + 8
                    note2 = (currentOctave * 12 + 3) + 8
                    note3 = (currentOctave * 12 + 10) + 8
                case 10:
                    note1 = (currentOctave * 12) + 9
                    note2 = (currentOctave * 12 + 3) + 9
                    note3 = (currentOctave * 12 + 10) + 9
                case 11:
                    note1 = (currentOctave * 12) + 10
                    note2 = (currentOctave * 12 + 3) + 10
                    note3 = (currentOctave * 12 + 10) + 10
                case 12:
                    note1 = (currentOctave * 12) + 11
                    note2 = (currentOctave * 12 + 3) + 11
                    note3 = (currentOctave * 12 + 10) + 11
                default:
                    note1 = (currentOctave * 12)
                    note2 = (currentOctave * 12 + 3)
                    note3 = (currentOctave * 12 + 10)
                }
                
            }
            
        }
        
    }
    
    /*
    //
    MARK: PAN GESTURE
    //
    */
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        targetView.addGestureRecognizer(panGesture)
    }
    
    func handlePan(panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translationInView(view)
        panGesture.setTranslation(CGPointZero, inView: view)
        print(translation)
        
        
        //create a new Label and give it the parameters of the old one
        let label = panGesture.view as! UIImageView
        label.center = CGPoint(x: label.center.x+translation.x, y: label.center.y+translation.y)
        label.multipleTouchEnabled = true
        label.userInteractionEnabled = true
        
    }
    
    
    /*
    //
    MARK: OUTLET ACTIONS
    //
    */
    
    // buttonPressed: the start of a synth note
    // The synth engine should begin playing
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        prepareToPlayChord(sender.tag, playOrStop: "play")
        
    }
    
    // buttonReleased: the end of a note
    // The synth engine should stop playing
    
    @IBAction func buttonReleased(sender: AnyObject) {
        
        prepareToPlayChord(sender.tag, playOrStop: "stop")
        
    }
    
    @IBAction func buttonReleasedOutside(sender: AnyObject) {
        
        prepareToPlayChord(sender.tag, playOrStop: "stop")
        
    }

}
