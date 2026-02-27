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
    static let levelOne: [Note] = [
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
    ]
    
    static let otherLevelOne: [Note] = []

    static let levelTwo: [Note] = [
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
        
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .c5),
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .e4),
    ]
    
    static let otherLevelTwo: [Note] = []
    
    static let levelThree: [Note] = [
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
        
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .c5),
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .e4),
        
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
        
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .c5),
        Note(duration: .half, pitch: .b4),
    ]
    
    static let otherLevelThree: [Note] = []

    static let levelFour: [Note] = [
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
        
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .c5),
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .e4),
        
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
        
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .c5),
        Note(duration: .half, pitch: .b4),
    ]
    
    static let otherLevelFour: [Note] = [
        Note(duration: .half, pitch: .d3),
        Note(duration: .half, pitch: .f3)
    ]
    
    static let levelFive: [Note] = [
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
        
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .c5),
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .e4),
        
        Note(duration: .eighth, pitch: .f4),
        Note(duration: .eighth, pitch: .e4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .a4),
        Note(duration: .quarter, pitch: .b4),
        
        Note(duration: .quarter, pitch: .b4),
        Note(duration: .quarter, pitch: .c5),
        Note(duration: .half, pitch: .b4),
    ]
    
    static let otherLevelFive: [Note] = [
        Note(duration: .half, pitch: .d3),
        Note(duration: .half, pitch: .f3),
        
        Note(duration: .half, pitch: .c3),
        Note(duration: .half, pitch: .f3),
        
        Note(duration: .half, pitch: .d3),
        Note(duration: .half, pitch: .f3),
        
        Note(duration: .half, pitch: .c3),
        Note(duration: .half, pitch: .a3),
    ]
    
}

// For testing
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
