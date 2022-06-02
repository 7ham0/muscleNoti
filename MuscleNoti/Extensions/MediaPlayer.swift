//
//  MediaPlayer.swift
//  MuscleNoti
//
//  Created by Giorgi Shamugia on 02.06.22.
//

import UIKit
import MediaPlayer

//Update system volume
extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.02) {
            slider?.value = volume
        }
    }
}
