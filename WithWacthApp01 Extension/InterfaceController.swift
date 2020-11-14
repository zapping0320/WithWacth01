//
//  InterfaceController.swift
//  WithWacthApp01 Extension
//
//  Created by DONGHYUN KIM on 2020/11/14.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

    private var session = WCSession.default
    
    private var currnetTextValue:String = ""
    @IBAction func textFieldAction(_ value: NSString?) {
        self.currnetTextValue = value as! String
    }
    
    @IBOutlet weak var receivedMessageFromApp: WKInterfaceLabel!
    @IBOutlet weak var sendMessage: WKInterfaceTextField!
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        if isSuported() {
            session.delegate = self
            session.activate()
        }
        self.sendMessage.setText("" )
        self.receivedMessageFromApp.setText("")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    private func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    private func isReachable() -> Bool {
        return session.isReachable
    }
    
    @IBAction func sendMessageToApp() {
        if isReachable() {
            self.receivedMessageFromApp.setText("")
            session.sendMessage(["request" : self.currnetTextValue], replyHandler: { (response) in
                //self.items.append("Reply: \(response)")
                print("Reply: \(response)")
                DispatchQueue.main.async {
                    self.receivedMessageFromApp.setText("Reply: \(response)")
                }
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
        } else {
            print("iPhone is not reachable!!")
            self.receivedMessageFromApp.setText("iPhone is not reachable!!")
        }
    }
    
}

extension InterfaceController: WCSessionDelegate {
    
    // 4: Required stub for delegating session
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // 1: We launch a sound and a vibration
        WKInterfaceDevice.current().play(.notification)
        // 2: Get message and append to list
        guard let msg = message["msg"] as? String else { return }
        DispatchQueue.main.async {
            self.receivedMessageFromApp.setText("from app: \(msg) ")
        }
    }
    
}
