//
//  ContentView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/23/26.
//

import SwiftUI

struct ContentView: View {
    
    let blocks: [Block] = [Block(id: UUID(), type: .note, position: .zero, children: []),
                           Block(id: UUID(), type: .note, position: CGPoint(x: 0, y: 100), children: [])]
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack {
                ForEach(blocks) { block in
                    BlockView(position: block.position)
                }
            }
        }
    }
    
//    func trySnap(block: Block, to other: Block) {
//        let distance = hypot(
//            block.position.x - other.position.x,
//            block.position.y - other.position.y
//        )
//
//        if distance < 40 {
//            connect(block, to: other)
//        }
//    }
}

#Preview {
    ContentView()
}
