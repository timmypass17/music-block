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
            print("Did set active notes")
            visibleNotes = Array(repeating: false, count: activeNotes.count)
        }
    }
    @Published var visibleNotes: [Bool] = []
    
    @Published var otherActiveNotes: [Note] = [] {
        didSet {
            print("Did set other active notes")
            otherVisibleNotes = Array(repeating: false, count: otherActiveNotes.count)
        }
    }
    @Published var otherVisibleNotes: [Bool] = []
    
    
    @Published var scrollPosition = ScrollPosition(idType: Note.ID.self)
    @Published var otherScrollPosition = ScrollPosition(idType: Note.ID.self)

    @Published var functionBlockOptions: [UUID: FunctionBlockData] = [:]
    
    let blockHeight: CGFloat = 60
    let snapDistance: CGFloat = 40
    let blockSpacing: CGFloat = 4
    let audioManager = AudioManager()
    let otherAudioManager = AudioManager()

    var levels: [Level] = Level.all
    @Published var currentLevelIndex = 0
    var currentLevel: Level {
        return levels[currentLevelIndex]
    }
    @Published var isShowingHintSheet = false
    @Published var isShowingCompleteSheet = false
    
    var rightPlayBlockID: UUID = UUID()
    var leftPlayBlockID: UUID?
    
    var enablePlayBlockButton: Bool {
        let playBlockCount = blocks.count(where: { $0.value is PlayBlock })
        return playBlockCount < 2
    }

    func getUserNotes(playBlockID: UUID) -> [Note] {
        // Find play block
        guard let playBlock = blocks.first(where: { $0.key == playBlockID })?.value as? PlayBlock else {
            print("Fail to find play block")
            return []
        }
        
        // Start notes
        return getUserNotes(playBlock.next)
    }
    
    func getUserNotes(_ head: UUID?) -> [Note] {
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
                notes.append(contentsOf: getUserNotes(functionBlock.value.next))
            }
            current = blocks[cid]?.next
        }
        return notes
    }
    
    func play() async {
        let expectedNotes: [Note] = currentLevel.notes
        let otherExpectedNotes: [Note] = currentLevel.otherNotes

        let notes: [Note] = getUserNotes(playBlockID: rightPlayBlockID)
        activeNotes = notes
        
        let otherNotes: [Note]
        if let leftPlayBlockID {
            otherNotes = getUserNotes(playBlockID: leftPlayBlockID)
        } else {
            otherNotes = []
        }
        otherActiveNotes = otherNotes
        
        var res: Bool = true
        
        if notes.count != expectedNotes.count {
            print("Right hand notes have different counts \(notes.count) != \(expectedNotes.count)")
            res = false
        }
        
        if otherNotes.count != otherExpectedNotes.count {
            print("Left hand notes have different counts \(otherNotes.count) != \(otherExpectedNotes.count)")
            res = false
        }
        
        async let passed1 = playNotes(notes, expectedNotes, true)
        async let passed2 = playNotes(otherNotes, otherExpectedNotes, false)
        let (result1, result2) = await (passed1, passed2)
        print("Results1: \(result1)")
        print("Results2: \(result2)")

        if res {
            res = result1 && result2
        }
        
        print("Final Result: \(res)")
        
        if res && !currentLevel.completed {
            levels[currentLevelIndex].completed = true
            isShowingCompleteSheet = true
        }
    }
    
    func playNotes(_ notes: [Note], _ expectedNotes: [Note], _ isRightHand: Bool) async -> Bool {
        let staffLength = 700
        var passed: Bool = true

        for (index, note) in notes.enumerated() {
            // Ensure animation always plays
            withAnimation(.smooth(duration: note.duration.rawValue)) {
                if isRightHand {
                    visibleNotes[index] = true
                    scrollPosition.scrollTo(x: xNoteOffset(notes, index) - CGFloat((staffLength / 2)))
                } else {
                    otherVisibleNotes[index] = true
                    otherScrollPosition.scrollTo(x: xNoteOffset(notes, index) - CGFloat((staffLength / 2)))
                }
            }
            
            if isRightHand {
                await audioManager.play(pitch: note.pitch, duration: note.duration)
            } else {
                await otherAudioManager.play(pitch: note.pitch, duration: note.duration)
            }
            
            if index < expectedNotes.count {
                if note != expectedNotes[index] {
                    passed = false
                }
            }
        }
        
        return passed
    }
    
    func addBlock(_ block: any Block) {
        blocks[block.id] = block
    }
    
    func getFunctionName(functionID: UUID) -> String {
        guard let functionBlock = blocks.first(where: { $0.key == functionID })?.value as? FunctionBlock else { return "" }
        return functionBlock.name
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
