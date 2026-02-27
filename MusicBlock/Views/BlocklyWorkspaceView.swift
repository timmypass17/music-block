//
//  BlocklyWorkspaceView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import SwiftUI

struct BlocklyWorkspaceView: View {
    @StateObject var workspace = BlockWorkspace()
    @State var baseOffset: Double = -26.808
    @State var spacing: Double = 7.9578
    @State var barYOffset: Double = 60.80
//    
//    @State var slashWidth: Double = 5
//    @State var slashXOffset: Double = 10
//    @State var slashYOffset: Double = 10
//    @State var slashSpacing: Double = 12.4
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack {
                    HStack(spacing: 16) {
                        ForEach(1..<6) { i in
                            Button {
                                
                            } label: {
                                Text("\(i)")
                                    .frame(width: 30, height: 30)
                                    .padding(4)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                            }
                            .buttonStyle(.plain)
                        }
                    }
//                    .border(.orange)
                    .padding(.top, 35)
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    StaffView(
//                        baseOffset: $baseOffset,
//                         spacing: $spacing,
//                         barYOffset: $barYOffset,
//                        slashWidth: $slashWidth,
//                        slashXOffset: $slashXOffset,
//                        slashYOffset: $slashYOffset,
//                        slashSpacing: $slashSpacing,
                        userNotes: workspace.activeNotes, visibleNotes: workspace.visibleNotes)
                        .environmentObject(workspace)
//                        .border(.blue)
                    StaffView(
                        userNotes: workspace.activeNotes, visibleNotes: workspace.visibleNotes)
                        .environmentObject(workspace)
                    
                    
//                    Slider(value: $baseOffset, in: -200...200)
//                    Text("\(baseOffset)")
//                    Slider(value: $spacing, in: 0...50)
//                    Text("\(spacing)")
//                    Slider(value: $barYOffset, in: 0...200)
//                    Text("\(barYOffset)")
                    
//                    Slider(value: $slashWidth, in: 0...50)
//                    Text("\(slashWidth)")
//                    Slider(value: $slashXOffset, in: -100...100)
//                    Text("\(slashXOffset)")
//                    Slider(value: $slashYOffset, in: -10...100)
//                    Text("\(slashYOffset)")
//                    Slider(value: $slashSpacing, in: -10...100)
//                    Text("\(slashSpacing)")

//                    StaffView(userNotes: workspace.activeNotes, visibleNotes: workspace.visibleNotes)
//                        .environmentObject(workspace)
                    Spacer()
                }
                .padding(.top, 100)
                
                ForEach(Array(workspace.blocks.keys), id: \.self) { id in
                    Group {
                        switch workspace.blocks[id] {
                        case is PlayBlock:
                            PlayBlockView(blockID: id)
                        case is NoteBlock:
                            NoteBlockView(blockID: id)
                        case is FunctionBlock:
                            FunctionBlockView(blockID: id)
                        case is FunctionInstanceBlock:
                            FunctionInstanceBlockView(blockID: id)
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
                        DropdownFunctionMenu(fromTop: true, onTapNewBlockOption: {
                            // Add function block
                            let center = CGPoint(
                                x: geo.size.width / 2,
                                y: geo.size.height / 2
                            )
                            
                            let functionBlock = FunctionBlock(
                                position: center
                            )
                            
                            workspace.addBlock(functionBlock)
                        }) { option in
                            // Add function block instance
                            let center = CGPoint(
                                x: geo.size.width / 2,
                                y: geo.size.height / 2
                            )
                            
                            let functionInstanceBlock = FunctionInstanceBlock(
                                position: center,
                                name: workspace.getFunctionName(functionID: option.functionBlockID),
                                functionBlockID: option.functionBlockID
                            )
                            
                            workspace.addBlock(functionInstanceBlock)
                        }
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
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {

                        } label: {
                            Image(systemName: "questionmark")
                                .foregroundStyle(.black)
                        }
                    }
                }
                
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

//#Preview {
//    BlocklyWorkspaceView()
//}
