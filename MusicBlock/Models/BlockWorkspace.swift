//
//  BlockWorkspace.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import Foundation
import Combine
import SwiftUI

struct FunctionBlockData {
    var functionBlockID: UUID
}

@MainActor
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
    
    @Published var scrollPosition = ScrollPosition(idType: Note.ID.self)

    @Published var functionBlockOptions: [UUID: FunctionBlockData] = [:]
    
    let blockHeight: CGFloat = 60
    let snapDistance: CGFloat = 40
    let blockSpacing: CGFloat = 4
    let audioManager = AudioManager()
    
    func getNotes() -> [Note] {
        // Find play block
        guard let playBlock = blocks.first(where: { $0.value is PlayBlock })?.value as? PlayBlock else {
            print("Fail to find play block")
            return []
        }
        
        // Start notes
        return getNotes(playBlock.next)
    }
    
    func getNotes(_ head: UUID?) -> [Note] {
        var notes: [Note] = []
        
        // Iterate through linked list
        var current: UUID? = head

        while let cid = current {
            // play block code
            if let noteBlock = blocks[cid] as? NoteBlock {
                notes.append(noteBlock.note)
            } else if let functionInstBlock = blocks[cid] as? FunctionInstanceBlock,
                      let functionBlockID = functionInstBlock.functionBlockID,
                      let functionBlock = blocks.first(where: { $0.key == functionBlockID })
            {
                // Get notes starting at function
                notes.append(contentsOf: getNotes(functionBlock.value.next))
            }
            current = blocks[cid]?.next
        }
        return notes
    }
    
//    func getNotes() -> [Note] {
//        var notes: [Note] = []
//        guard let playBlock = blocks.first(where: { $0.value is PlayBlock })?.value as? PlayBlock else { return notes }
//        
//        // Iterate through linked list
//        var current: UUID? = playBlock.next
//
//        while let cid = current {
//            // play block code
//            if let noteBlock = blocks[cid] as? NoteBlock {
//                notes.append(noteBlock.note)
//            } else if let functionInstBlock = blocks[cid] as? FunctionInstanceBlock,
//                let functionBlockID = functionInstBlock.functionBlockID {
//                notes.append(contentsOf: getFunctionNotes(functionBlockID: functionBlockID))
//            }
//            current = blocks[cid]?.next
//        }
//        return notes
//    }
    
//    func getFunctionNotes(functionBlockID: UUID) -> [Note] {
//        var notes: [Note] = []
//        
//        guard let functionBlock = blocks.first(where: { $0.value is FunctionBlock })?.value as? FunctionBlock else { return [] }
//        var current: UUID? = functionBlock.next
//
//        while let cid = current {
//            if let noteBlock = blocks[cid] as? NoteBlock {
//                notes.append(noteBlock.note)
//            } else if let functionInstBlock = blocks[cid] as? FunctionInstanceBlock,
//                let functionBlockID = functionInstBlock.functionBlockID {
//                notes.append(contentsOf: getFunctionNotes(functionBlockID: functionBlockID))
//            }
//            current = blocks[cid]?.next
//        }
//        
//        return notes
//    }
    
    func play() async {
        let notes: [Note] = getNotes()
        let staffLength = 700
        activeNotes = notes

        for (index, note) in notes.enumerated() {
            // Ensure animation always plays
            withAnimation(.smooth(duration: note.duration.rawValue)) {
                visibleNotes[index] = true
                scrollPosition.scrollTo(x: xNoteOffset(notes, index) - CGFloat((staffLength / 2)))
            }
            await audioManager.play(pitch: note.pitch, duration: note.duration)
        }
        
        
        activeNotes.removeAll()
    }
    
    func addBlock(_ block: any Block) {
        blocks[block.id] = block
    }
    
    func getFunctionName(functionID: UUID) -> String {
        guard let functionBlock = blocks.first(where: { $0.key == functionID })?.value as? FunctionBlock else { return "" }
        return functionBlock.name
    }
    
    func addFunction(functionId: UUID) {
//        functionBlockOptions[functionId] = FunctionBlockData(name: <#T##String#>, functionBlockID: <#T##UUID?#>)
    }
    
    func connect(parent: UUID, child: UUID) {
        let temp = blocks[parent]?.next
        blocks[parent]?.next = child
        blocks[child]?.previous = parent
        
        if temp != nil {
            blocks[child]?.next = temp
            blocks[temp!]?.previous = child
        }
        
        
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
        guard dragged is NoteBlock || dragged is FunctionInstanceBlock else { return }
        
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
