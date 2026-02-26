//
//  AudioManager.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/25/26.
//

import Foundation
import AVFAudio

class AudioManager {
    
    private var players: [Pitch: AVAudioPlayer] = [:]
    
    var bpm: Double = 120
    
    private var secondsPerBeat: Double {
        60.0 / bpm
    }
    
    init() {
        preloadSounds()
    }
    
    // Load all audio files once
    private func preloadSounds() {
        for note in Pitch.allCases {
            if let url = Bundle.main.url(forResource: note.description, withExtension: "mp3") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    players[note] = player
                } catch {
                    print("Failed to load \(note): \(error)")
                }
            }
        }
    }
    
    // Play note
    func play(pitch: Pitch, duration: NoteDuration) async {
        guard let player = players[pitch] else {
            print("Missing player for \(pitch)")
            return
        }
        
        player.currentTime = 0
        player.play()
        
        let durationSeconds = secondsPerBeat * duration.rawValue
        
        try? await Task.sleep(for: .seconds(durationSeconds))
        
        player.stop()
    }
}
