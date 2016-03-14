//
//  PatchBrowser.swift
//  FinalProject
//
//  Created by Samuel Johnson on 3/14/16.
//  Copyright © 2016 Samuel Johnson. All rights reserved.
//

import UIKit
import Foundation

class PatchBrowser: UITableViewController {
    
    var numberOfFiles = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfFiles
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        return 2
//    }
    
}
