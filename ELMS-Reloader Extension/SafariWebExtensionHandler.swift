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
    // On MacOS10.15 with Xcode12.0.1, having a custom OSLog and logging with it leads app crash.
    // Instead of using custom log, use OSLog.default
    // let logger = OSLog(subsystem: "io.github.westelh.ELMS-Reloader", category: "SafariExtensionNativeContainer")
    
    //定義済みメッセージタイプとそれに対するアクション
    let messageTypesAndDelegates = [
        "request":meetRequest
    ]
    
    func respondToBrowserMessage(_ message: [AnyHashable:Any]) -> [AnyHashable:Any]? {
        os_log("Entered respondToBrowsermessage()", log: OSLog.default, type: .debug)
        // 定義済みメッセージタイプにマッチするメッセージ内容を走査
        for (messageType, dwelegate) in messageTypesAndDelegates {
            os_log("Message type enumeration started. now:%@", log: logger, type: .debug, messageType)
            if let contentOfType = message[messageType] {
                os_log("Received message has explicit type \"%@\". Passing to the delegate corresponds.", log: logger, type: .info, messageType)
                return delegate(self)(contentOfType as? String ?? "")
            }
        }
        os_log("Received message does not match any type of message defined.", log: logger, type: .error)
        return nil
    }
    
	func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems.first as! NSExtensionItem
        
        var response: [AnyHashable:Any]?
        if let message = item.userInfo?[SFExtensionMessageKey] as? [AnyHashable:Any] {
            os_log("Received message from browser.runtime.sendMesssage()", log: OSLog.default, type: .default)
            response = respondToBrowserMessage(message)
        } else {
            os_log("No data in the location expected for it to be in", log: OSLog.default, type: .error)
        }
        
        context.completeRequest(returningItems: [response ?? [] ], completionHandler: nil)
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
            os_log("No operation for the request content:%{public}@", log: OSLog.default, type: .error, requestContent)
        }
        return content
    }
}
