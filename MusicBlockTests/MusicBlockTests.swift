//
//  MusicBlockTests.swift
//  MusicBlockTests
//
//  Created by Timmy Nguyen on 2/23/26.
//

import Testing
@testable import MusicBlock
import Foundation

@MainActor
struct MusicBlockTests {

    let workspace = BlockWorkspace()
    
    @Test
    func addBlock() throws {
        assert(workspace.blocks.isEmpty)

        let playBlock = PlayBlock()
        workspace.addBlock(playBlock)
        #expect(workspace.blocks.count == 1)
        #expect(workspace.blocks.contains(where: { $0.key == playBlock.id }))
    }
    
    @Test
    func connectNotes() throws {
        let playBlock = PlayBlock()
        workspace.addBlock(playBlock)
        
        let noteBlock1 = NoteBlock(note: Note(duration: .quarter, pitch: .c4))
        let noteBlock2 = NoteBlock(note: Note(duration: .quarter, pitch: .d4))
        let noteBlock3 = NoteBlock(note: Note(duration: .quarter, pitch: .e4))
        workspace.addBlock(noteBlock1)
        workspace.addBlock(noteBlock2)
        workspace.addBlock(noteBlock3)

        workspace.connect(parent: playBlock.id, child: noteBlock1.id)
        workspace.connect(parent: noteBlock1.id, child: noteBlock2.id)
        workspace.connect(parent: noteBlock2.id, child: noteBlock3.id)

        let expectedNotes: [Note] = [noteBlock1, noteBlock2, noteBlock3].map { $0.note }
        var i = 0
        var current: UUID? = playBlock.id
        while let cid = current {
            if let noteBlock = workspace.blocks[cid] as? NoteBlock {
                #expect(noteBlock.note == expectedNotes[i - 1])
            }
            i += 1
            current = workspace.blocks[cid]?.next
        }
        
        #expect(i == 4)
    }
    
    @Test("Play song with functions (e.g. play -> m1 (a, b, c) -> m2 (d, e, f))")
    func playFunctions() throws {
        let playBlock = PlayBlock()
        workspace.addBlock(playBlock)
        
        // Create m1 function
        let f1 = FunctionBlock(name: "m1")
        workspace.addBlock(f1)
        
        let n1 = NoteBlock(note: Note(duration: .quarter, pitch: .a3))
        let n2 = NoteBlock(note: Note(duration: .quarter, pitch: .b3))
        let n3 = NoteBlock(note: Note(duration: .quarter, pitch: .c3))
        workspace.addBlock(n1)
        workspace.addBlock(n2)
        workspace.addBlock(n3)
        
        workspace.connect(parent: f1.id, child: n1.id)
        workspace.connect(parent: n1.id, child: n2.id)
        workspace.connect(parent: n2.id, child: n3.id)
        
        // Create m2 function
        let f2 = FunctionBlock(name: "m2")
        workspace.addBlock(f2)
        
        let n4 = NoteBlock(note: Note(duration: .quarter, pitch: .d3))
        let n5 = NoteBlock(note: Note(duration: .quarter, pitch: .e3))
        workspace.addBlock(n4)
        workspace.addBlock(n5)
        
        workspace.connect(parent: f2.id, child: n4.id)
        workspace.connect(parent: n4.id, child: n5.id)

        // Create function instances
        let m1Inst = FunctionInstanceBlock(functionBlockID: f1.id)
        workspace.addBlock(m1Inst)
        
        let m2Inst = FunctionInstanceBlock(functionBlockID: f2.id)
        workspace.addBlock(m2Inst)
        
        workspace.connect(parent: playBlock.id, child: m1Inst.id)
        workspace.connect(parent: m1Inst.id, child: m2Inst.id)

        let expectedNotes: [Note] = [n1, n2, n3, n4, n5].map { $0.note }
        
        let notes = workspace.getNotes()
        #expect(notes.count == expectedNotes.count)

        for i in notes.indices {
            #expect(notes[i] == expectedNotes[i])
        }
    }
    
    
    @Test("Play song nested functions (e.g. play -> m1 (a -> b -> c -> m2 (d -> e))")
    func playFunctions2() throws {
        let playBlock = PlayBlock()
        workspace.addBlock(playBlock)
        
        // Create m2 function
        let f2 = FunctionBlock(name: "m2")
        workspace.addBlock(f2)
        
        let n4 = NoteBlock(note: Note(duration: .quarter, pitch: .d3))
        let n5 = NoteBlock(note: Note(duration: .quarter, pitch: .e3))
        workspace.addBlock(n4)
        workspace.addBlock(n5)
        
        workspace.connect(parent: f2.id, child: n4.id)
        workspace.connect(parent: n4.id, child: n5.id)
        
        let m2Inst = FunctionInstanceBlock(functionBlockID: f2.id)
        workspace.addBlock(m2Inst)
        
        // Create m1 function
        let f1 = FunctionBlock(name: "m1")
        workspace.addBlock(f1)
        
        let n1 = NoteBlock(note: Note(duration: .quarter, pitch: .a3))
        let n2 = NoteBlock(note: Note(duration: .quarter, pitch: .b3))
        let n3 = NoteBlock(note: Note(duration: .quarter, pitch: .c3))
        workspace.addBlock(n1)
        workspace.addBlock(n2)
        workspace.addBlock(n3)
        
        workspace.connect(parent: f1.id, child: n1.id)
        workspace.connect(parent: n1.id, child: n2.id)
        workspace.connect(parent: n2.id, child: n3.id)
        workspace.connect(parent: n3.id, child: m2Inst.id)
        
        // Create function instances
        let m1Inst = FunctionInstanceBlock(functionBlockID: f1.id)
        workspace.addBlock(m1Inst)
        
        workspace.connect(parent: playBlock.id, child: m1Inst.id)

        let expectedNotes: [Note] = [n1, n2, n3, n4, n5].map { $0.note }
        
        let notes = workspace.getNotes()
        #expect(notes.count == expectedNotes.count)

        for i in notes.indices {
            #expect(notes[i] == expectedNotes[i])
        }
    }
    
    
    @Test("Play song mixed notes and functions (e.g. play -> a -> m1 (b, c) -> d")
    func playFunctions3() throws {
        let playBlock = PlayBlock()
        workspace.addBlock(playBlock)
        
        let n1 = NoteBlock(note: Note(duration: .quarter, pitch: .a3))
        workspace.addBlock(n1)
        
        let f1 = FunctionBlock(name: "m1")
        workspace.addBlock(f1)
        let n2 = NoteBlock(note: Note(duration: .quarter, pitch: .b3))
        workspace.addBlock(n2)
        let n3 = NoteBlock(note: Note(duration: .quarter, pitch: .c3))
        workspace.addBlock(n3)
        
        workspace.connect(parent: f1.id, child: n2.id)
        workspace.connect(parent: n2.id, child: n3.id)
        
        let m1 = FunctionInstanceBlock(functionBlockID: f1.id)
        workspace.addBlock(m1)
        
        let n4 = NoteBlock(note: Note(duration: .quarter, pitch: .d3))
        workspace.addBlock(n4)

        workspace.connect(parent: playBlock.id, child: n1.id)
        workspace.connect(parent: n1.id, child: m1.id)
        workspace.connect(parent: m1.id, child: n4.id)
        
        let expectedNotes: [Note] = [n1, n2, n3, n4].map { $0.note }
        
        let notes = workspace.getNotes()
        #expect(notes.count == expectedNotes.count)

        for i in notes.indices {
            #expect(notes[i] == expectedNotes[i])
        }
    }
}
