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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sendMessageToWatch(_ sender: Any) {
        let message = "Message \(self.messageTextField.text)"

        connectivityHandler.sendMessage(msg: message)
    }
    
}

