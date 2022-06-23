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
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var deviceTimeMonitor = Timer()
    var choosenDate: Date?
    var deviceDate = Date()
    var components = DateComponents()
    var musicTimer = Timer()
    var musicCanPlay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.datePickerMode = UIDatePicker.Mode.time
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
        prepareTriger()
    }
    
    func prepareTriger() {
        self.components.year = Date().get(.year)
        self.components.day = Date().get(.day)
        self.components.month = Date().get(.month)
        self.components.hour = datePicker.date.get(.hour)
        self.components.minute = datePicker.date.get(.minute)
        self.components.second = datePicker.date.get(.second)
        self.components.timeZone = NSTimeZone.system
        
        self.choosenDate = NSCalendar.autoupdatingCurrent.date(from: components)
        
        print("choosenDate: \(components)")
        print("deviceDate: \(Date())")
        print("choosenDate2: \(choosenDate ?? Date())")
        
        // timer for chack if device time has been changed
        deviceTimeMonitor = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(isDeviceTimeChanged), userInfo: nil, repeats: true)
    }
    
    func triggerMusicAndNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Alarm is playing"
        content.subtitle = "Tap to stop sound"
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        // add our notification request
        UNUserNotificationCenter.current().add(request)
        self.playCustomSound()
    }
    
    // - chack for device time change
    @objc func isDeviceTimeChanged() {
        self.deviceDate = Date()
        
        if self.musicCanPlay == false && deviceDate.get(.hour) <= choosenDate?.get(.hour) ?? 0 && deviceDate.get(.minute) <= choosenDate?.get(.minute) ?? 0 && deviceDate.get(.second) <= choosenDate?.get(.second) ?? 0{
            self.musicCanPlay = true
        }
        
        if self.musicCanPlay == true && deviceDate.get(.hour) == choosenDate?.get(.hour) ?? 0 && deviceDate.get(.minute) == choosenDate?.get(.minute) ?? 0 {
            
            self.triggerMusicAndNotification()
            self.musicCanPlay = false
        }
    }
    
    @objc func playCustomSound() {
        // Make volume 70%
        MPVolumeView.setVolume(0.7)
        MNSounds.shared.playSound(.success,atTime: 1.0)
    }
}

