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
