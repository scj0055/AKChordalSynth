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
    INSTANCE VARIABLES
    */
    //
    
    var sampler = AKSampler()
    
    /*
    //
    OUTLET CONNECTIONS
    //
    */
    
    /*
    //
    LIFECYCLE
    //
    */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let bundle = NSBundle.mainBundle()
        let samplerFile = bundle.pathForResource("sawPiano1", ofType: "exs")
        
        print(samplerFile)
        
        //sampler.loadEXS24(samplerFile!)
        
        //AudioKit.output = sampler
        //AudioKit.start()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    //
    OUTLET ACTIONS
    //
    */
    
    // buttonPressed: the start of a synth note
    // The synth engine should begin playing
    
    @IBAction func buttonPressed(sender: AnyObject) {
        print(sender.tag)
        print("button pressed")
        
        sampler.playNote(75)
        
    }
    
    
    // buttonReleased: the end of a note
    // The synth engine should stop playing
    
    @IBAction func buttonReleased(sender: AnyObject) {
        print(sender.tag)
        print("button released")
    }

}
