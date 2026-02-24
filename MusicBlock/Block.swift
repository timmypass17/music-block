//
//  Block.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/23/26.
//

import Foundation

struct Block: Identifiable {
    let id: UUID
    var type: BlockType
    var position: CGPoint
    var connectedTo: UUID?
    var children: [UUID]
}

enum BlockType {
    case note
    case loop(Int)
}
