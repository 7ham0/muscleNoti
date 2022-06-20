//
//  MNSounds.swift
//  MuscleNoti
//
//  Created by Giorgi Shamugia on 27.05.22.
//

import UIKit
import AVFoundation
import MediaPlayer



enum SoundType {
    case success
    case silent
    
    var source: String {
        switch self {
        case .success:
            return "beastie_boys_sabotage"
        case .silent:
            return "1-minute-of-silence"
        }
    }
}

class MNSounds {
    static let shared = MNSounds()
    
    private var player: AVAudioPlayer?
    
    func playSound(_ type: SoundType, atTime: TimeInterval = 0) {
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
                self.player?.prepareToPlay()
                self.player?.volume = 0.7
                self.player?.numberOfLoops = -1
                self.player?.play(atTime: (self.player?.deviceCurrentTime ?? 0.0) + atTime)
            }
        }
        catch {
            print(error)
        }
    }
    
    func playWithoutSound() {
        guard let soundFileURL = Bundle.main.url(
            forResource: "1-minute-of-silence", withExtension: "wav"
        ) else {
            return
        }
        
        var audioFile = AVAudioFile()
        
        do {
            audioFile = try AVAudioFile(forReading: soundFileURL)
        } catch {
            print(error)
        }
        
        let audioFormat = audioFile.processingFormat
        let audioEngine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()

        // Attach the player node to the audio engine.
        audioEngine.attach(playerNode)

        // Connect the player node to the output node.
        audioEngine.connect(playerNode,
                            to: audioEngine.outputNode,
                            format: audioFormat )
        
        
        playerNode.scheduleFile(audioFile,
                                at: nil,
                                completionCallbackType: .dataPlayedBack) { _ in
            /* Handle any work that's necessary after playback. */
            
            
        }
        
        do {
            try audioEngine.start()
//            playerNode.play()
            
            print("audioEngine is running: \(audioEngine.isRunning)")
            print("playerNode is playing: \(playerNode.isPlaying)")
        } catch {
            /* Handle the error. */
            print(error)
        }
    }
    
    func stopSound() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            DispatchQueue.main.async {
                self.player?.stop()
            }
        }
        catch {
            print(error)
        }
    }
}
