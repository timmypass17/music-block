//
//  FunctionBlock.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/25/26.
//

import Foundation

struct FunctionBlock: Block {
    let id = UUID()
    var position: CGPoint
    var previous: UUID? = nil
    var next: UUID? = nil
}
