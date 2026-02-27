//
//  Level.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/26/26.
//

import Foundation

struct Level {
    let notes: [Note]
    let otherNotes: [Note]
    let showLeft: Bool
    let enableFunctionBlock: Bool
    var available: Bool
    var completed: Bool
}

extension Level {
    static let all: [Level] = [
        Level(notes: Note.longLevel, otherNotes: Note.otherLongLevel, showLeft: true, enableFunctionBlock: true, available: true, completed: false),
        Level(notes: Note.levelZero, otherNotes: [], showLeft: false, enableFunctionBlock: false, available: false, completed: false),
        Level(notes: Note.levelZero, otherNotes: [], showLeft: false, enableFunctionBlock: true, available: false, completed: false),
        Level(notes: Note.levelZero, otherNotes: [], showLeft: true, enableFunctionBlock: true, available: false, completed: false),
        Level(notes: Note.levelZero, otherNotes: [], showLeft: true, enableFunctionBlock: true, available: false, completed: false)
    ]
}
