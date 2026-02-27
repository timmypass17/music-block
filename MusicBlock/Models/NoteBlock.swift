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
}
