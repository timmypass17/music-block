//
//  BlocklyWorkspaceView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import SwiftUI

struct BlocklyWorkspaceView: View {
    @StateObject var workspace = BlockWorkspace()
//    @State var baseOffset: Double = -18
//    @State var spacing: Double = 10
//
//    @State var barHeight: Double = 50
//    @State var barOffset: Double = 20
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack {
                    StaffView(userNotes: workspace.activeNotes, visibleNotes: workspace.visibleNotes)
                    Spacer()
//                    VStack {
//                        Slider(
//                            value: $barHeight,
//                            in: 0...100,
//                            onEditingChanged: { editing in
//                            }
//                        )
//                        Text("\(barHeight)")
//                    }
//                    VStack {
//                        Slider(
//                            value: $barOffset,
//                            in: 0...100,
//                            onEditingChanged: { editing in
//                            }
//                        )
//                        Text("\(barOffset)")
//                    }
//                    VStack {
//                        Slider(
//                            value: $baseOffset,
//                            in: -35...0,
//                            onEditingChanged: { editing in
//                            }
//                        )
//                        Text("\(baseOffset)")
//                    }
//                    VStack {
//                        Slider(
//                            value: $spacing,
//                            in: 0...20,
//                            onEditingChanged: { editing in
//                            }
//                        )
//                        Text("\(spacing)")
//                    }
                }
//                VStack {
//                    VStack {
//                        Image("stave")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 700, height: 120)
//                            .border(.blue)
//                        Image("stave")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 700, height: 120)
//                            .border(.blue)
//                    }
//                    .overlay {
//                        ForEach(Song.song1) { note in
//                            NoteView(note: note)
//                        }
////                        ForEach(Array(workspace.blocks.keys), id: \.self) { id in
////                            if workspace.blocks[id] is NoteBlock {
////                                NoteView(blockID: id)
////                                    .environmentObject(workspace)
////                            }
////                        }
//                    }
//                    Spacer()
//                }
                                
                ForEach(Array(workspace.blocks.keys), id: \.self) { id in
                    Group {
                        switch workspace.blocks[id] {
                        case is PlayBlock:
                            PlayBlockView(blockID: id)
                        case is NoteBlock:
                            NoteBlockView(blockID: id)
                        default:
                            EmptyView()
                        }
                    }
                    .environmentObject(workspace)
                    .zIndex(workspace.selectedBlockID == id ? 1000 : 0)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            let center = CGPoint(
                                x: geo.size.width / 2,
                                y: geo.size.height / 2
                            )
                            
                            let note = NoteBlock(
                                position: center,
                                note: Note(duration: .quarter, pitch: .c4)
                            )
                            
                            workspace.addBlock(note)
                        } label: {
                            HStack {
                                Image(systemName: "music.note")
                                Text("Note Block")
                            }
                        }
                        DropdownFunctionMenu(fromTop: true, options: ["New Block"])
                            .environmentObject(workspace)
//                        Button {
//                            
//                        } label: {
//                            HStack {
//                                Image(systemName: "cube.fill")
//                                Text("Function Block")
//                            }
//                        }
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    
                }
            }
            .toolbar {
//                ToolbarItem(placement: .bottomBar) {
//
//                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            Task {
                                await workspace.play()
                            }
                        } label: {
                            Image(systemName: "play.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
            .onAppear {
                setupBlocks()
            }
        }
    }
    
    func setupBlocks() {
        let play = PlayBlock(
            position: CGPoint(x: 200, y: 100)
        )
        
        let note1 = NoteBlock(
            position: CGPoint(x: 200, y: 200),
            note: Note(duration: .quarter, pitch: .c4)
        )
        
        let note2 = NoteBlock(
            position: CGPoint(x: 200, y: 400),
            note: Note(duration: .quarter, pitch: .d4)
        )
        
        workspace.addBlock(play)
        workspace.addBlock(note1)
        workspace.addBlock(note2)
    }
}

#Preview {
    BlocklyWorkspaceView()
}
