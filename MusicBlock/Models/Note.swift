//
//  Note.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import Foundation

struct Note: Identifiable {
    var id = UUID()
    var duration: NoteDuration
    var pitch: Pitch
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return
            lhs.duration == rhs.duration &&
            lhs.pitch == rhs.pitch
    }
}

extension Note {
    static let levelZero: [Note] = [
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4)
    ]
    static let otherLevelZero: [Note] = [
        Note(duration: .quarter, pitch: .d4),
        Note(duration: .quarter, pitch: .e4),
        Note(duration: .quarter, pitch: .f4)

    ]
    static let levelOne: [Note] = [
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
    ]
    
    static let longLevel: [Note] = [
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
    ]
    
    static let otherLongLevel: [Note] = [
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .c4),
    ]
}
