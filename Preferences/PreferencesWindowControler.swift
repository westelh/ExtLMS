//
//  PreferencesWindowControler.swift
//  ExtLMS
//
//  Created by 西海泰成 on 2020/10/17.
//

import Cocoa

class PreferencesWindowControler: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        self.window?.orderOut(sender)
        return false
    }

}
