//
//  ViewController.swift
//  ELMS-Reloader
//
//  Created by 西海泰成 on 2020/10/16.
//

import Cocoa
import SafariServices.SFSafariApplication
import SafariServices.SFSafariExtensionManager

let appName = "ELMS-Reloader"
let extensionBundleIdentifier = "io.github.westelh.ELMS-Reloader-Extension"

class ViewController: NSViewController, NSWindowDelegate {

    @IBOutlet var appNameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appNameLabel.stringValue = appName
        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                if (state.isEnabled) {
                    self.appNameLabel.stringValue = NSLocalizedString("拡張機能は有効化されています", comment:"\(appName)'s extension is currently on.")
                } else {
                    self.appNameLabel.stringValue =
                        NSLocalizedString(
                            "ELMS Reloaderの拡張機能は無効にされています。Safari拡張機能設定から有効化してください。",
                            comment: "\(appName)'s extension is currently off. You can turn it on in Safari Extensions preferences.")
                }
            }
        }
    }
    
    @IBAction func openSafariExtensionPreferences(_ sender: AnyObject?) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            guard error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
