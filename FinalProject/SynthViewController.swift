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
    var currentChordType = "major"
    var currentRibbonNote = 0
    var masterVolume = 80
    
    var enableRibbonController = true
    
    var loadCount = 0
    
    var isAudioKitStarted = false
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // effects
    var delayTime:Double = 0.1
    var delayFeedback:Double = 0.4
    var delayMix:Double = 0.3
    
    var reverbMix:Double = 2.0
    var reverbTime:Double = 1.0
    
    var note1 = 44
    var note2 = 48
    var note3 = 51

    /*
    //
    MARK: OUTLET CONNECTIONS
    //
    */
    
    @IBOutlet weak var seventhLabel: UILabel!
    
    @IBOutlet weak var currentPatchName: UILabel!
    
    @IBOutlet weak var octaveLabel: UILabel!
    
    // DELAY
    @IBOutlet weak var dMixSlider: UISlider!
    @IBOutlet weak var dFdbkSlider: UISlider!
    @IBOutlet weak var dTimeSlider: UISlider!
    
    // REVERB
    @IBOutlet weak var reverbTimeSlider: UISlider!
    @IBOutlet weak var reverbMixSlider: UISlider!
    
    @IBOutlet weak var masterVolumeSlider: UISlider!
    
    /*
    //
    MARK: LIFECYCLE
    //
    */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set the labels for the UI
        self.octaveLabel.text = "Current Octave: \(self.currentOctave)"
        self.seventhLabel.text = "7th Chords: \(majorOrMinorSeventh)"
        self.currentPatchName.text = "Current Patch: \(currentPatch)"
        
        loadPatch(self.currentPatch)
        
        print(loadCount)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentCount = NSUserDefaults.standardUserDefaults().integerForKey("launchCount")
        
        if currentCount > 3 {
            showRateMe()
        }
    }
    
    /*
    //
    APP RATINGS
    //
    */
    
    func showRateMe() {
        
        let alert = UIAlertController(title: "Rate Us", message: "Thanks for using AKChordalSynth", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Rate AKChordalSynth", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
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
        
        print("Loading patch. AudioKit Started: \(self.isAudioKitStarted)")
        
        AudioKit.stop()
        self.isAudioKitStarted = false
        
        // load the new patch
        sampler.loadWav(patchToLoad)
        self.currentPatch = patchToLoad
        self.currentPatchName.text = "Current Patch: \(patchToLoad)"
        
        // initiate the delay
        let delay = AKDelay(sampler)
        delay.dryWetMix = self.delayMix
        delay.feedback = self.delayFeedback
        delay.time = self.delayTime
        
        // initiate the reverb
        let reverb = AKReverb2(delay)
        reverb.dryWetMix = self.reverbMix
        reverb.decayTimeAt0Hz = self.reverbTime
        reverb.start()
        
        AudioKit.output = reverb
        
        // start audioKit
        AudioKit.start()
        self.isAudioKitStarted = true
        
        print("Patch Loaded. AudioKit Started: \(self.isAudioKitStarted)")
        
        self.loadCount++
        
    }
    
    /*
    //
    MARK: RIBBON CONTROLLER
    //
    */
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            if touch.view!.accessibilityIdentifier! == "ribbon" {
                
                let position = touch.locationInView(self.view)
                let noteVal = calcNoteValue(position.y)
                
                if noteVal != self.currentRibbonNote {
                    
                    if loadCount == 1 {
                        playRibbonNote(noteVal + 1)
                        print("Note played: \(noteVal + 1)")
                    }
                    
                }
                
                self.currentRibbonNote = noteVal
                
            }
        }
    }
    
    
    // calculate which 12th of the screen we're dragging in
    func calcNoteValue(yPos: CGFloat) -> Int {
        
        let segmentHeight = screenSize.height / 12
        
        return Int(floor(yPos / segmentHeight))
        
    }
    
    func playRibbonNote(currentNote: Int) {
        
        switch currentNote {
        case 1:
            playNote(note1 - 12)
        case 2:
            playNote(note2 - 12)
        case 3:
            playNote(note3 - 12)
        case 4:
            playNote(note1)
        case 5:
            playNote(note2)
        case 6:
            playNote(note3)
        case 7:
            playNote(note1 + 12)
        case 8:
            playNote(note2 + 12)
        case 9:
            playNote(note3 + 12)
        case 10:
            playNote(note1 + 24)
        case 11:
            playNote(note2 + 24)
        default:
            playNote(note1)
        }
        
    }
    
    func stopRibbonNote(currentNote: Int) {
        
        switch currentNote {
        case 1:
            stopNote(note1 - 12)
        case 2:
            stopNote(note2 - 12)
        case 3:
            stopNote(note3 - 12)
        case 4:
            stopNote(note1)
        case 5:
            stopNote(note2)
        case 6:
            stopNote(note3)
        case 7:
            stopNote(note1 + 12)
        case 8:
            stopNote(note2 + 12)
        case 9:
            stopNote(note3 + 12)
        case 10:
            stopNote(note1 + 24)
        case 11:
            stopNote(note2 + 24)
        default:
            stopNote(note1)
        }
        
    }
    
    /*
    //
    MARK: SOUND CONTROL
    //
    */
    
    func playChord() {
        
        sampler.playNote(self.note1, velocity: self.masterVolume, channel: 0)
        sampler.playNote(self.note2, velocity: self.masterVolume, channel: 0)
        sampler.playNote(self.note3, velocity: self.masterVolume, channel: 0)
    }
    
    func stopChord() {
        sampler.stopNote(self.note1, channel: 0)
        sampler.stopNote(self.note2, channel: 0)
        sampler.stopNote(self.note3, channel: 0)
    }
    
    func playNote(note: Int) {
        
        if self.isAudioKitStarted {
            sampler.playNote(note, velocity: self.masterVolume, channel: 0)
        } 
    }
    
    func stopNote(note: Int) {
        
        sampler.stopNote(note, channel: 0)
    }
    
    // helper function - takes in the tag value of a button and calculates the chord value
    // then, plays the actual chord
    
    func prepareToPlayChord(senderTag: Int, playOrStop: String) {
        
        if senderTag < 200 {
            
            let chordToPlay = senderTag - 100
            calculateChord("major", currentChord: chordToPlay, currentOctave: self.currentOctave)
            self.currentChordType = "major"
            
        } else if senderTag < 300 {
            
            let chordToPlay = senderTag - 200
            calculateChord("minor", currentChord: chordToPlay, currentOctave: self.currentOctave)
            self.currentChordType = "minor"
            
        } else if senderTag < 400 {
            
            let chordToPlay = senderTag - 300
            calculateChord("seventh", currentChord: chordToPlay, currentOctave: self.currentOctave)
            self.currentChordType = "seventh"
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

    @IBAction func octaveUp(sender: UIButton) {
        self.currentOctave = self.currentOctave + 1
        self.octaveLabel.text = "Current Octave: \(self.currentOctave)"
    }
    
    @IBAction func octaveDown(sender: AnyObject) {
        self.currentOctave = self.currentOctave - 1
        self.octaveLabel.text = "Current Octave: \(self.currentOctave)"
    }
    
    @IBAction func changeSeventh(sender: UIButton) {
        if self.majorOrMinorSeventh == "major" {
            self.majorOrMinorSeventh = "minor"
        } else {
            self.majorOrMinorSeventh = "major"
        }
        self.seventhLabel.text = "7th Chords: \(majorOrMinorSeventh)"
    }
    
    // DELAY
    
    @IBAction func sliderChanged(sender: UISlider) {
        self.delayMix = Double(dMixSlider.value)
        loadPatch(self.currentPatch)
        print("Delay Mix: \(self.delayMix)")
    }
    
    @IBAction func dTimeModified(sender: UISlider) {
        self.delayTime = Double(dTimeSlider.value)
        loadPatch(self.currentPatch)
        print("Delay Time: \(self.delayTime)")
    }
    
    @IBAction func dFeedbackModified(sender: UISlider) {
        self.delayFeedback = Double(dFdbkSlider.value)
        loadPatch(self.currentPatch)
        print("Delay Feedback: \(self.delayFeedback)")
    }
    
    // REVERB
    
    @IBAction func reverbTimeModified(sender: UISlider) {
        self.reverbTime = Double(reverbTimeSlider.value)
        loadPatch(self.currentPatch)
        print("Reverb Time: \(self.reverbTime)")
    }
    
    @IBAction func reverbMixModified(sender: UISlider) {
        self.reverbMix = Double(reverbMixSlider.value)
        loadPatch(self.currentPatch)
        print("Reverb Mix: \(self.reverbMix)")
    }
    
    @IBAction func masterVolumeModified(sender: UISlider) {
        self.masterVolume = Int(floor(masterVolumeSlider.value))
        print("Master Volume: \(masterVolume)")
    }
}
