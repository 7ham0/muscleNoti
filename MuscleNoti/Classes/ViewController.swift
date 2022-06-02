//
//  ViewController.swift
//  MuscleNoti
//
//  Created by Giorgi Shamugia on 27.05.22.
//

import UIKit
import MediaPlayer
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secundTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourTextField.placeholder = "00"
        minuteTextField.placeholder = "00"
        secundTextField.placeholder = "00"
    }
    
    @IBAction func startTimer(_ sender: AnyObject) {
        DispatchQueue.main.async {
            self.playSound()
        }
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                               to: UIApplication.shared, for: nil)
    }
    
    
    func playSound() {
        
        let hourIs = Int(self.hourTextField.text ?? "0")
        let minuteIs = Int(self.minuteTextField.text ?? "0")
        let secundIs = Int(self.secundTextField.text ?? "0")
        
        var timeInterval: TimeInterval = 0
        
        timeInterval = timeInterval + (timeInterval.addHour(hourIs ?? 0) ?? 0.0)
        timeInterval = timeInterval + (timeInterval.addMinute(minuteIs ?? 0) ?? 0.0)
        timeInterval = timeInterval + Double((secundIs ?? 0))
        
        print("timeIntervalIs: ",timeInterval)
        
        MPVolumeView.setVolume(0.7)
        
        trigerNotification(interVal: timeInterval - 1)
        MNSounds.shared.playSound(.success, atTime: timeInterval) //time is a TimeInterval after which the audio will start
    }
    
    func trigerNotification(interVal: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "stop"
        content.subtitle = "tap to stop sound"
        content.sound = .none

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interVal, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}

