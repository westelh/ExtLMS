//
//  SafariWebExtensionHandler.swift
//  ELMS-Reloader Extension
//
//  Created by 西海泰成 on 2020/10/16.
//

import SafariServices
import os

let SFExtensionMessageKey = "message"
let UserRequestValue = "UserRequest"
let PassRequestValue = "PassRequest"
let UserKeyInDefault = "User"
let PassKeyInDefault = "Pass"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    let defaults = UserDefaults(suiteName: "io.github.westelh.ELMS-Reloader.group")
    let logger = OSLog(subsystem: "io.github.westelh.ELMS-Reloader", category: "SafariExtensionNativeContainer")
    
	func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems.first as! NSExtensionItem
        var response: [AnyHashable:Any]?
        if let message = item.userInfo?[SFExtensionMessageKey] as? [AnyHashable:Any] {
            os_log("Received message from browser.runtime.sendMesssage()", log: logger, type: .default)
            response = respondToBrowserMessage(message)
        } else {
            os_log("No data in the location expected for it to be in", log: logger, type: .error)
        }
        
        let ret = NSExtensionItem()
        ret.userInfo?.updateValue(response ?? [:], forKey: SFExtensionMessageKey)
        context.completeRequest(returningItems: [ret], completionHandler: nil)
    }
    
    func respondToBrowserMessage(_ message: [AnyHashable:Any]) -> [AnyHashable:Any]? {
        if let requestContent = message["request"] as? String {
            os_log("At subroutine switch, message content(%{public}@) is being passed to request process.", log: logger, type: .info, requestContent)
            return meetRequest(requestContent: requestContent)
        }

        os_log("Received message does not match any type of message defined.", log: logger, type: .error)
        return nil
    }
    
    func meetRequest(requestContent: String) -> [AnyHashable:Any] {
        var content = [AnyHashable:Any]()
        switch requestContent {
        case UserRequestValue:
            content = ["value":defaults?.string(forKey: UserKeyInDefault) ?? ""]; break
        case PassRequestValue:
            content = ["value":defaults?.string(forKey: PassKeyInDefault) ?? ""]; break
        default:
            content = ["error":String(format: "No operation for the request content:%@", requestContent)]
            os_log("No operation for the request content:%{public}@", log: logger, type: .error, requestContent)
        }
        return content
    }
}
