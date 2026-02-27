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
    var showLeft: Bool {
        return !otherNotes.isEmpty
    }
    let enableFunctionBlock: Bool
    var available: Bool
    var completed: Bool
}

extension Level {
    static let all: [Level] = [
        Level(notes: Note.levelZero, otherNotes: Note.otherLevelOne, enableFunctionBlock: true, available: true, completed: false),
        Level(notes: Note.levelTwo, otherNotes: Note.otherLevelTwo, enableFunctionBlock: false, available: false, completed: false),
        Level(notes: Note.levelThree, otherNotes: Note.otherLevelThree, enableFunctionBlock: true, available: false, completed: false),
        Level(notes: Note.levelFour, otherNotes: Note.otherLevelFour, enableFunctionBlock: true, available: false, completed: false),
        Level(notes: Note.levelFive, otherNotes: Note.otherLevelFive, enableFunctionBlock: true, available: false, completed: false)
    ]
}
