//
//  SplashScreenController.swift
//  FinalProject
//
//  Created by Samuel Johnson on 3/16/16.
//  Copyright © 2016 Samuel Johnson. All rights reserved.
//

import UIKit

class SplashScreenController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "transitionView", userInfo: nil, repeats: false)
    }
    
    func transitionView() {
        self.performSegueWithIdentifier("goToMain", sender: self)
    }
    

}
