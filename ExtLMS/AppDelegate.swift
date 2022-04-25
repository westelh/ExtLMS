//
//  AppDelegate.swift
//  ExtLMS
//
//  Created by 西海泰成 on 2020/10/16.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var preferencesControler: NSWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed (_ theApplication: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        if !(preferencesControler != nil) {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Preferences"), bundle: nil)
            preferencesControler = storyboard.instantiateInitialController() as? NSWindowController
        }
        
        if preferencesControler != nil {
            preferencesControler!.showWindow(sender)
        }
    }
    
}
