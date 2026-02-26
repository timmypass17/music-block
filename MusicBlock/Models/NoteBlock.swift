//
//  Block.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/23/26.
//

import Foundation
import AVFoundation

protocol Block: Identifiable {
    var id: UUID { get }
    var position: CGPoint { get set }
    var previous: UUID? { get set }
    var next: UUID? { get set }
}

struct NoteBlock: Block {
    let id = UUID()
    var position: CGPoint = .zero
    var previous: UUID? = nil
    var next: UUID? = nil
    
    var note: Note
    
    func play() async {
        print("play(\(note.duration), \(note.pitch.description))")

        do {
            if let url = Bundle.main.url(forResource: "C4", withExtension: "mp3") {
                let player = try AVAudioPlayer(contentsOf: url)
                player.play()
                try await Task.sleep(for: .seconds(note.duration.rawValue))
                player.stop()
            }
        } catch {
            print("Error getting audio: \(error)")
        }
    }
}
