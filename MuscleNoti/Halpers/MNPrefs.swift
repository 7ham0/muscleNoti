//
//  MNPrefs.swift
//  MuscleNoti
//
//  Created by Giorgi Shamugia on 15.06.22.
//

import Foundation
import UIKit

class MNPrefs {
    
    class var shared: MNPrefs {
        struct Static {
            static let instance = MNPrefs()
        }
      
        return Static.instance
    }
    
    private let defaults = UserDefaults.standard
  
    private let alarmIsActive = "alarmIsActive"
    
    func alarmIsRunning() -> Bool {
        return defaults.bool(forKey: alarmIsActive)
    }
    
    func changeAlarmStatus(isAvtive: Bool) {
        defaults.setValue(isAvtive, forKey: alarmIsActive)
    }
    
}
