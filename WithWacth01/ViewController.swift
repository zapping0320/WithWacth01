//
//  ViewController.swift
//  WithWacth01
//
//  Created by DONGHYUN KIM on 2020/11/14.
//

import UIKit

class ViewController: UIViewController {

    var connectivityHandler = SessionHandler.shared
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var alarmPicker: UIDatePicker!
    
    
    private var granted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestAuthrization()
    }
    
    func requestAuthrization(){
        let center = UNUserNotificationCenter.current()
        //center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Permission granted. Scheduling notification")
                //self.scheduleNotification()
                self.granted = granted
            }
        }
    }

    @IBAction func sendMessageToWatch(_ sender: Any) {
        let message = "Message \(self.messageTextField.text)"

        connectivityHandler.sendMessage(msg: message)
    }
    
    @IBAction func setAlarm(_ sender: Any) {
        addNotification()
    }
    
    func addNotification() {
        let date = self.alarmPicker.date
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "알람alarm", arguments: nil)
        var dateInfo = DateComponents()
        dateInfo.hour = 23//date.get(.hour)
        dateInfo.minute = 20//date.get(.minute)
        dateInfo.weekday = 7
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        
        let identifier = UUID().uuidString
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: identifier , content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
}

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
