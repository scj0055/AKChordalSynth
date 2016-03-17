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
    
    var enableRibbonController = false
    
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
    
    @IBOutlet weak var enableRibbon: UISwitch!
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
        
        enableRibbon.setOn(false, animated: true)
        self.enableRibbonController = self.enableRibbon.on
        
        print("Ribbon controller is: \(enableRibbonController)")
        
        dispatch_async(dispatch_get_main_queue(), {
            self.loadPatch(self.currentPatch)
            return
        })
        
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
    
    /// Shows a "rate me" view 
    /// -Attribution: http://www.brianjcoleman.com/tutorial-rate-me-using-uialertview-in-swift/
    
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
    
    /// Loads a patch into the audio engine
    /// -Parameter patchToLoad: the name of the patch to load, as a string
    /// -Attribution: AudioKit documentation
    
    func loadPatch(patchToLoad: String) {
        
        print("Loading patch. AudioKit Started: \(self.isAudioKitStarted)")
        printDebug()
        
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
        
        stopAllNotes()
        
        print("Patch Loaded. AudioKit Started: \(self.isAudioKitStarted)")
        
        self.loadCount++
        
    }
    
    func printDebug() {
        
        print("*** DEBUG LOG ***")
        print("Current Octave: \(self.currentOctave)")
        print("Current Patch: \(self.currentPatch)")
        print("Seventh: \(self.majorOrMinorSeventh)")
        print("Chord Type: \(self.currentChordType)")
        print("Note 1: \(self.note1)")
        print("Note 2: \(self.note2)")
        print("Note 3: \(self.note3)")
        print("Current Ribbon Note: \(self.currentRibbonNote)")
        print("MasterVolume: \(self.masterVolume)")
        print("*** END DEBUG LOG ***")
    }
    
    /*
    //
    MARK: RIBBON CONTROLLER
    //
    */
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if enableRibbonController {
            
            if let touch = touches.first {
                
                if touch.view!.accessibilityIdentifier! == "ribbon" {
                    
                    let position = touch.locationInView(self.view)
                    let noteVal = calcNoteValue(position.y)
                    
                    print("noteVal: \(noteVal)")
                    print("curr ribbon: \(self.currentRibbonNote)")
                    
                    if noteVal != self.currentRibbonNote {
                        playRibbonNote()
                        print("Note played: \(noteVal + 1)")
                    }
                    
                    self.currentRibbonNote = noteVal
                }
            }
        
        }
        
    }
    
    /// Helper function that decides which note to play for the ribbon controller
    /// -Parameter yPos: the y position of the current tap
    /// -Attribution: class, lecture
    
    // calculate which 12th of the screen we're dragging in
    func calcNoteValue(yPos: CGFloat) -> Int {
        
        let segmentHeight = screenSize.height / 12
        
        return Int(floor(yPos / segmentHeight))
        
    }
    
    /*
    //
    MARK: SOUND CONTROL
    //
    */
    
    /// Plays a note on the ribbon controller, based on the current note value
    /// -Parameter currentNote: the note to play
    
    func playRibbonNote() {
        
        print("MIDI Note Played - Ribbon: \(self.currentRibbonNote)")
        
        switch self.currentRibbonNote {
        case 1:
            sampler.playNote(
                self.note1 - 12, velocity: self.masterVolume, channel: 1)
        case 2:
            sampler.playNote(self.note2 - 12, velocity: self.masterVolume, channel: 1)
        case 3:
            sampler.playNote(self.note3 - 12, velocity: self.masterVolume, channel: 1)
        case 4:
            sampler.playNote(self.note1, velocity: self.masterVolume, channel: 1)
        case 5:
            sampler.playNote(self.note2, velocity: self.masterVolume, channel: 1)
        case 6:
            sampler.playNote(self.note3, velocity: self.masterVolume, channel: 1)
        case 7:
            sampler.playNote(self.note1 + 12, velocity: self.masterVolume, channel: 1)
        case 8:
            sampler.playNote(self.note2 + 12, velocity: self.masterVolume, channel: 1)
        case 9:
            sampler.playNote(self.note3 + 12, velocity: self.masterVolume, channel: 1)
        case 10:
            sampler.playNote(self.note1 + 24, velocity: self.masterVolume, channel: 1)
        case 11:
            sampler.playNote(self.note2 + 24, velocity: self.masterVolume, channel: 1)
        default:
            sampler.playNote(self.note1, velocity: self.masterVolume, channel: 1)
        }
        
    }
    
    /// Stops a note on the ribbon controller, based on the current note value
    /// -Parameter currentNote: the note to stop
    
    func stopRibbonNote(currentNote: Int) {
        
        switch self.currentRibbonNote {
        case 1:
            sampler.stopNote(self.note1 - 12, channel: 1)
        case 2:
            sampler.stopNote(self.note2 - 12, channel: 1)
        case 3:
            sampler.stopNote(self.note3 - 12, channel: 1)
        case 4:
            sampler.stopNote(self.note1, channel: 1)
        case 5:
            sampler.stopNote(self.note2, channel: 1)
        case 6:
            sampler.stopNote(self.note3, channel: 1)
        case 7:
            sampler.stopNote(self.note1 + 12, channel: 1)
        case 8:
            sampler.stopNote(self.note2 + 12, channel: 1)
        case 9:
            sampler.stopNote(self.note3 + 12, channel: 1)
        case 10:
            sampler.stopNote(self.note1 + 24, channel: 1)
        case 11:
            sampler.stopNote(self.note2 + 24, channel: 1)
        default:
            sampler.stopNote(self.note1, channel: 1)
        }
        
    }
    
    /// Plays a chord, based on the current notes to be played.
    /// -Attribution: AudioKit documentation
    
    func playChord() {
        
        sampler.playNote(self.note1, velocity: self.masterVolume, channel: 1)
        sampler.playNote(self.note2, velocity: self.masterVolume, channel: 1)
        sampler.playNote(self.note3, velocity: self.masterVolume, channel: 1)
    }
    
    /// Plays a chord, based on the current notes to be played.
    /// -Attribution: AudioKit documentation
    
    func stopChord() {
        sampler.stopNote(self.note1, channel: 1)
        sampler.stopNote(self.note2, channel: 1)
        sampler.stopNote(self.note3, channel: 1)
    }
    
    // stops all possible notes
    func stopAllNotes() {
        
        for index in 1...127 {
            sampler.stopNote(index, channel:1)
        }
        
    }
    
    /// Helper function - takes in the tag value of a button and calculates the chord value
    /// -Parameter senderTag: the tag value of the button that triggered the event
    /// -Parameter playOrStop: either play the note, or stop the note
    
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
    
    /// Main function that decides the notes for a chord
    /// -Parameter currentType: is the current type major, minor, or seventh
    /// -Parameter currentChord: the chord to play (one of the 12 notes in the scale)
    /// -Parameter currentOctave: the current octave of the instrument
    
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
    
    /// -Attribution: All of these came from lecture/previous projects
    
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
    @IBAction func enableRibbonAction(sender: UISwitch) {
        self.enableRibbonController = sender.on
        print("Ribbon Enabled: \(self.enableRibbonController)")
    }
}
