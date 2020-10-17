//
//  SafariWebExtensionHandler.swift
//  ELMS-Reloader Extension
//
//  Created by 西海泰成 on 2020/10/16.
//

import SafariServices
import os.log
import os

let SFExtensionMessageKey = "message"
let UserRequestValue = "UserRequest"
let PassRequestValue = "PassRequest"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

	func beginRequest(with context: NSExtensionContext) {
        let defaults = UserDefaults(suiteName: "io.github.westelh.ELMS-Reloader.group")
        
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey] as! [AnyHashable:Any]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)

        let response = NSExtensionItem()
        let request = message["request"]! as! String
        if defaults == nil {
            os_log("defaults is nil")
        }
        let user = defaults?.string(forKey: "User")
        let pass = defaults?.string(forKey: "Pass")
        if request=="User" {
            response.userInfo = [ SFExtensionMessageKey: [ "value": user] ]
        } else if request=="Pass" {
            response.userInfo = [ SFExtensionMessageKey: [ "value": pass] ]
        }
            
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
    
}
