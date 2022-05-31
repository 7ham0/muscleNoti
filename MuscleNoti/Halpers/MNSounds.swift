//
//  MNSounds.swift
//  MuscleNoti
//
//  Created by Giorgi Shamugia on 27.05.22.
//

import UIKit
import AVFoundation



enum SoundType {
    case success
    
    var source: String {
        switch self {
        case .success:
            return "beastie_boys_sabotage"
        }
    }
}

class MNSounds {
    static let shared = MNSounds()
    
    private var player: AVAudioPlayer?
    
    func playSound(_ type: SoundType, atTime: TimeInterval) {
        guard let soundFileURL = Bundle.main.url(
            forResource: type.source, withExtension: "mp3"
        ) else {
            return
        }
        
        do {
            // Configure and activate the AVAudioSession
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                options: [AVAudioSession.CategoryOptions.duckOthers,
                AVAudioSession.CategoryOptions.mixWithOthers]
            )
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Play a sound
            self.player = try AVAudioPlayer(
                contentsOf: soundFileURL
            )
            
            DispatchQueue.main.async {
                self.player?.play(atTime: (self.player?.deviceCurrentTime ?? 0.0) + atTime)
            }
        }
        catch {
            print(error)
        }
    }
}
