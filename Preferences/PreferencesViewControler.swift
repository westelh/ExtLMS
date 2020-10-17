//
//  PreferencesViewControler.swift
//  ELMS-Reloader
//
//  Created by 西海泰成 on 2020/10/17.
//

import Cocoa

class PreferencesViewControler: NSViewController {
    
    let defaults = UserDefaults(suiteName: "io.github.westelh.ELMS-Reloader.group")
    var previousUser = ""
    var previousPass = ""
    
    @IBOutlet var button: NSButton?
    @IBOutlet var userInput: NSTextField?
    @IBOutlet var passInput: NSSecureTextField?
    @IBOutlet var appInfo: NSTextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let releaseVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        
        appInfo?.stringValue += "\nRelease version: " + releaseVersion + "\n"
        appInfo?.stringValue += "Build version: " + buildVersion + "\n"
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.parent?.view.window?.title = self.title ?? ""
        let user = defaults?.string(forKey: "User") ?? ""
        let pass = defaults?.string(forKey: "Pass") ?? ""
        userInput?.stringValue = user
        passInput?.stringValue = pass
        previousUser = user
        previousPass = pass
    }
    
    @IBAction func sendUserInput(_ sender: NSTextField) {
        if previousUser != sender.stringValue {
            previousUser = sender.stringValue
            button?.isEnabled = true
        }
    }
    
    @IBAction func sendPassInput(_ sender: NSTextField) {
        if previousPass != sender.stringValue {
            previousPass = sender.stringValue
            button?.isEnabled = true
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        defaults?.set(userInput?.stringValue, forKey: "User")
        defaults?.set(passInput?.stringValue, forKey: "Pass")
        defaults?.synchronize()
        button?.isEnabled = false
    }
    
}
