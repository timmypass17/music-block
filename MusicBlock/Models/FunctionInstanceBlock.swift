//
//  FunctionBlock.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/25/26.
//

import Foundation
internal import CoreGraphics

struct FunctionInstanceBlock: Block {
    let id = UUID()
    var position: CGPoint = .zero
    var previous: UUID? = nil
    var next: UUID? = nil
    
    var name: String = ""
    var functionBlockID: UUID? = nil
    
}
