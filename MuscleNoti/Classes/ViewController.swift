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
    
    var deviceTimeMonitor = Timer()
    var choosenDate: Date?
    var deviceDate = Date()
    var components = DateComponents()
    var musicTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourTextField.placeholder = "00"
        minuteTextField.placeholder = "00"
        secundTextField.placeholder = "00"
    }
    
    @IBAction func startAlarm(_ sender: AnyObject) {
        deviceTimeMonitor.invalidate()
        self.playSound()
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                               to: UIApplication.shared, for: nil)
    }
    
    func playSound() {
        MNSounds.shared.playSound(.silent)
        MNPrefs.shared.changeAlarmStatus(isAvtive: true)
        trigerNotification()
    }
    
    func trigerNotification() {
        let content = UNMutableNotificationContent()
        content.interruptionLevel = .timeSensitive
        content.title = "Alarm is playing"
        content.subtitle = "Tap to stop sound"
        
        let hourIs = Int(self.hourTextField.text ?? "0")
        let minuteIs = Int(self.minuteTextField.text ?? "0")
        let secundIs = Int(self.secundTextField.text ?? "0")
        
        self.components.year = deviceDate.get(.year)
        self.components.day = deviceDate.get(.day)
        self.components.month = deviceDate.get(.month)
        self.components.hour = hourIs
        self.components.minute = minuteIs
        self.components.second = secundIs
        self.components.timeZone = NSTimeZone.system
        
        self.choosenDate = NSCalendar.autoupdatingCurrent.date(from: components)
        
        print("choosenDate: \(components)")
        print("deviceDate: \(Date())")
        print("choosenDate2: \(choosenDate ?? Date())")
        
        
        
        // - timer for music
        musicTimer = Timer(fireAt: choosenDate ?? Date(), interval: 1.0, target: self, selector: #selector(playCustomSound), userInfo: nil, repeats: false)
        RunLoop.main.add(musicTimer, forMode: .common)
        
        // trigger noti in date
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        // timer for chack if device time has been changed
        deviceTimeMonitor = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(isDeviceTimeChanged), userInfo: nil, repeats: true)
    }
    
    // - chack for device time change
    @objc func isDeviceTimeChanged() {
        self.deviceDate = Date()
        if deviceDate.timeIntervalSinceReferenceDate >= choosenDate?.timeIntervalSinceReferenceDate ?? Date().timeIntervalSinceReferenceDate && deviceDate.timeIntervalSinceReferenceDate <= ((choosenDate?.timeIntervalSinceReferenceDate ?? Date().timeIntervalSinceReferenceDate) + 1) {
            self.playCustomSound()
        }
        
        if deviceDate.timeIntervalSinceReferenceDate > ((choosenDate?.timeIntervalSinceReferenceDate ?? Date().timeIntervalSinceReferenceDate) + 1.5) {
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            deviceTimeMonitor.invalidate()
            musicTimer.invalidate()
            
        }
    }
    
    @objc func playCustomSound() {
        // Make volume 70%
        deviceTimeMonitor.invalidate()
        musicTimer.invalidate()
        MPVolumeView.setVolume(0.7)
        MNSounds.shared.playSound(.success)
    }
}

