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
    var description: String = ""
}

extension Level {
    static let all: [Level] = [
        Level(notes: Note.levelOne, otherNotes: Note.otherLevelOne, enableFunctionBlock: false, available: true, completed: false, description: """
            ✅ Goal: Play the opening notes **F4–E4–A4–A4–B4** from *Dango Daikazoku*!

            1. Tap **Note Block** at the bottom to add notes, then drag blocks together to build the melody.

            2. Press the **Start** button at the top right corner of the screen to play your melody
            """),
        Level(notes: Note.levelTwo, otherNotes: Note.otherLevelTwo, enableFunctionBlock: false, available: false, completed: false,
              description: """
              ✅ Goal: Add the next few notes!
              """),
        Level(notes: Note.levelThree, otherNotes: Note.otherLevelThree, enableFunctionBlock: true, available: false, completed: false,
              description: """
              ✅ Goal: Do you notice a pattern? Try creating a Function Block to group these notes together!
              
              1. Add a new **Function Block**
              
              2. Give your Function Block a name (e.g. "First Part")
              
              3. Add a **Function Block Instance**:
              Tap the Function Block button at the bottom, then select your function from the dropdown menu.
              """),
        Level(notes: Note.levelFour, otherNotes: Note.otherLevelFour, enableFunctionBlock: true, available: false, completed: false,
              description: """
              ✅ Goal: Add a second staff!
              
              1. Add a second **Play Block**
              
              2. Add the notes for the second staff
              """),
        Level(notes: Note.levelFive, otherNotes: Note.otherLevelFive, enableFunctionBlock: true, available: false, completed: false,
              description: """
              ✅ Goal: Complete the song *Dango Daikazoku*!
              
              1. You got this :)
              """)
    ]
}
