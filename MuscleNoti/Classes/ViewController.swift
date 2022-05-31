//
//  ViewController.swift
//  MuscleNoti
//
//  Created by Giorgi Shamugia on 27.05.22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startTimer(_ sender: AnyObject) {
        DispatchQueue.main.async {
            self.playSound()
        }
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                               to: UIApplication.shared, for: nil)
        
    }
    
    
    func playSound() {
        let timeInterval: TimeInterval = 5
        print("timeIntervalIs: ",timeInterval)
        MNSounds.shared.playSound(.success, atTime: timeInterval) //time is a TimeInterval after which the audio will start
    }
}

