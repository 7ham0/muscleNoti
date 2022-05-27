//
//  ViewController.swift
//  MuscleNoti
//
//  Created by Giorgi Shamugia on 27.05.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var counter: Double = 5.00 {
        didSet {
            if counter < 0.1 {
                // TODO: send notification
                
            }
        }
    }
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = String(counter)
    }
    
    @IBAction func startTimer(_ sender: AnyObject) {
        timer.invalidate()
        
        counter = 5.00
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func UpdateTimer() {
        if counter > 0.1 {
            counter = counter - 0.1
        }
        timeLabel.text = String(format: "%.1f", counter)
    }
}

