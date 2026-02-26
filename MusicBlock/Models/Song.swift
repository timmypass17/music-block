//
//  Song.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import Foundation
internal import CoreGraphics

struct Song {
    var blocks: [NoteBlock]
}

extension Song {
    static let song1: [Note] = [
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .d4),
        Note(duration: .quarter, pitch: .e4),
        Note(duration: .quarter, pitch: .c4),
        
        Note(duration: .quarter, pitch: .c4),
        Note(duration: .quarter, pitch: .d4),
        Note(duration: .quarter, pitch: .e4),
        Note(duration: .quarter, pitch: .c4),
        
        Note(duration: .quarter, pitch: .e4),
        Note(duration: .quarter, pitch: .f4),
        Note(duration: .half, pitch: .g4),
        
        Note(duration: .quarter, pitch: .e4),
        Note(duration: .quarter, pitch: .f4),
        Note(duration: .half, pitch: .g4),
        
//        Note(duration: .eighth, pitch: .g4),
//        Note(duration: .eighth, pitch: .a4),
//        Note(duration: .eighth, pitch: .g4),
//        Note(duration: .eighth, pitch: .f4),
//        Note(duration: .quarter, pitch: .e4),
//        Note(duration: .quarter, pitch: .c4),
//        
//        Note(duration: .eighth, pitch: .g4),
//        Note(duration: .eighth, pitch: .a4),
//        Note(duration: .eighth, pitch: .g4),
//        Note(duration: .eighth, pitch: .f4),
//        Note(duration: .quarter, pitch: .e4),
//        Note(duration: .quarter, pitch: .c4),
    ]
//    static let song1: [Note] = [
//        Note(duration: .quarter, pitch: .c3),
//        Note(duration: .quarter, pitch: .d3),
//        Note(duration: .quarter, pitch: .e3),
//        Note(duration: .quarter, pitch: .f3),
//        Note(duration: .quarter, pitch: .g3),
//        Note(duration: .quarter, pitch: .a3),
//        Note(duration: .quarter, pitch: .b3),
//        Note(duration: .quarter, pitch: .c4),
//        Note(duration: .quarter, pitch: .d4),
//        Note(duration: .quarter, pitch: .e4),
//        Note(duration: .quarter, pitch: .f4),
//        Note(duration: .quarter, pitch: .g4),
//        Note(duration: .quarter, pitch: .a4),
//    ]
}
