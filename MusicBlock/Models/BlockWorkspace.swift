//
//  BlockWorkspace.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import Foundation
import Combine
import SwiftUI

class BlockWorkspace: ObservableObject {
    @Published var blocks: [UUID: any Block] = [:]
    @Published var selectedBlockID: UUID? = nil
    @Published var activeNotes: [Note] = [] {
        didSet {
            visibleNotes = Array(repeating: false, count: activeNotes.count)
            print(visibleNotes)
        }
    }
    @Published var visibleNotes: [Bool] = []
    
    let blockHeight: CGFloat = 60
    let snapDistance: CGFloat = 40
    let blockSpacing: CGFloat = 4
    let audioManager = AudioManager()
    
    func getNotes() -> [Note] {
        var notes: [Note] = []
        guard let playBlock = blocks.first(where: { $0.value is PlayBlock })?.value as? PlayBlock
        else { return notes }
        
        // Iterate through linked list
        var current: UUID? = playBlock.next

        while let cid = current {
            // play block code
            if let noteBlock = blocks[cid] as? NoteBlock {
                notes.append(noteBlock.note)
            }
            current = blocks[cid]?.next
        }
        return notes
    }
    
    func play() async {
        let notes: [Note] = getNotes()
        activeNotes = notes

        for (index, note) in notes.enumerated() {
            withAnimation {
                visibleNotes[index] = true
            }
            await audioManager.play(pitch: note.pitch, duration: note.duration)
        }
        
        
        activeNotes.removeAll()
    }
    
    func addBlock(_ block: any Block) {
        blocks[block.id] = block
    }
    
    func connect(parent: UUID, child: UUID) {
        blocks[parent]?.next = child
        blocks[child]?.previous = parent
    }
    
    func disconnect(_ id: UUID) {
        if let prev = blocks[id]?.previous {
            blocks[prev]?.next = nil
        }
        blocks[id]?.previous = nil
    }
    
    func moveStack(from id: UUID, to position: CGPoint) {
        var current: UUID? = id
        var yOffset: CGFloat = 0
        
        while let cid = current {
            blocks[cid]?.position = CGPoint(
                x: position.x,
                y: position.y + yOffset
            )
            yOffset += blockHeight + blockSpacing
            current = blocks[cid]?.next
        }
    }
    
    func trySnap(_ id: UUID) {
        guard let dragged = blocks[id] else { return }
        
        for (otherID, other) in blocks {
            if otherID == id { continue }
            
            let targetY = other.position.y + blockHeight
            
            let yClose = abs(dragged.position.y - targetY) < snapDistance
            let xClose = abs(dragged.position.x - other.position.x) < 60
            
            if yClose && xClose {
                connect(parent: otherID, child: id)
                
                moveStack(
                    from: id,
                    to: CGPoint(
                        x: other.position.x,
                        y: targetY + blockSpacing
                    )
                )
                return
            }
        }
    }
}
