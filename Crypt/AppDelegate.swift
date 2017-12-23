//
//  AppDelegate.swift
//  Crypt
//
//  Created by Admin on 20/12/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let menu = NSMenu()
    var viewController = ViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "BitCoinStatusIcon") )
            button.action = #selector(statusButtonClicked(_:))
        }
    }
    
    @objc func statusButtonClicked(_ sender: Any?){
        print("Well done")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

