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
//                Color.white
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing: 64) {
                    HStack(spacing: 16) {
                        Button {
                            workspace.isShowingHintSheet.toggle()
                        } label: {
                            Image(systemName: "questionmark")
                                .foregroundStyle(.black)
                                .frame(width: 30, height: 30)
                                .padding(4)
                                .background(.white, in: RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                        }
                        
                        Spacer()
                        
                        ForEach(0..<5) { i in
                            Button {
                                workspace.currentLevelIndex = i
                                print("Level: \(workspace.currentLevelIndex)")
                            } label: {
                                Text("\(i + 1)")
                                    .foregroundStyle(.black)
                                    .frame(width: 30, height: 30)
                                    .padding(4)
                                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                            }
//                            .buttonStyle(.plain)
                            .disabled(!workspace.levels[i].available)
                            .opacity(workspace.levels[i].available ? 1 : 0.4)

                            if i < 4 {
                                Rectangle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(width: 10, height: 2)
                            }
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            if workspace.currentlyPlaying {
                                workspace.playTask?.cancel()
                            } else {
                                workspace.playTask = Task {
                                    await workspace.play()
                                }
                            }
                        } label: {
                            Image(systemName: workspace.currentlyPlaying ? "arrow.trianglehead.counterclockwise" : "play.fill")
                                .foregroundStyle(workspace.currentlyPlaying ? .red : .green)
                                .frame(width: 30, height: 30)
                                .padding(4)
                                .background(.white, in: RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                        }
                    }
//                    .border(.orange)
                    .padding()
                    
                    StaffView(
//                        baseOffset: $baseOffset,
//                         spacing: $spacing,
//                         barYOffset: $barYOffset,
//                        slashWidth: $slashWidth,
//                        slashXOffset: $slashXOffset,
//                        slashYOffset: $slashYOffset,
//                        slashSpacing: $slashSpacing,
                        notes: workspace.currentLevel.notes,
                        userNotes: workspace.activeNotes,
                        visibleNotes: workspace.visibleNotes,
                        scrollPosition: $workspace.scrollPosition
                    )
                        .environmentObject(workspace)
//                        .border(.blue)
                    
                    if workspace.currentLevel.showLeft {
                        StaffView(
                            notes: workspace.currentLevel.otherNotes,
                            userNotes: workspace.otherActiveNotes,
                            visibleNotes: workspace.otherVisibleNotes,
                            scrollPosition: $workspace.otherScrollPosition
                        )
                        .environmentObject(workspace)
                    }
                    
                    Spacer()
                }
                
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
                    HStack(spacing: 24) {
                        Button {
                            let center = CGPoint(
                                x: geo.size.width / 2,
                                y: geo.size.height - 200
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
                        
                        if workspace.currentLevel.enableFunctionBlock {
                            DropdownFunctionMenu(fromTop: true, onTapNewBlockOption: {
                                // Add function block
                                let center = CGPoint(
                                    x: geo.size.width / 2,
                                    y: geo.size.height / 2 - 200
                                )
                                
                                let functionBlock = FunctionBlock(
                                    position: center
                                )
                                
                                workspace.addBlock(functionBlock)
                            }) { option in
                                // Add function block instance
                                let center = CGPoint(
                                    x: geo.size.width / 2,
                                    y: geo.size.height / 2 - 200
                                )
                                
                                let functionInstanceBlock = FunctionInstanceBlock(
                                    position: center,
                                    name: workspace.getFunctionName(functionID: option.functionBlockID),
                                    functionBlockID: option.functionBlockID
                                )
                                
                                workspace.addBlock(functionInstanceBlock)
                            }
                            .environmentObject(workspace)
                        }
                        
                        if workspace.currentLevel.showLeft {
                            Button {
                                let center = CGPoint(
                                    x: geo.size.width / 2,
                                    y: geo.size.height / 2 - 200
                                )
                                
                                let playBlock = PlayBlock(
                                    position: center
                                )
                                workspace.leftPlayBlockID = playBlock.id
                                workspace.addBlock(playBlock)
                            } label: {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("Play Block")
                                }
                            }
                            .disabled(!workspace.enablePlayBlockButton)
                            .opacity(workspace.enablePlayBlockButton ? 1 : 0.4)
                        }
                    }
                    .padding()
                    .frame(height: 50)
                    .foregroundStyle(.black)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 2, y: 2)
                    
                }
            }

            .sheet(isPresented: $workspace.isShowingHintSheet, content: {
                if workspace.currentLevelIndex == 0 {
                    Sheet1View(title: "Level One", hints: Level.all[0].description, imageName: "hint-1")
                } else if workspace.currentLevelIndex == 1 {
                    Sheet1View(title: "Level Two", hints: Level.all[1].description)
                } else if workspace.currentLevelIndex == 2 {
                    Sheet1View(title: "Level Three",
                               hints: Level.all[2].description,
                               imageName: "hint-3")
                } else if workspace.currentLevelIndex == 3 {
                    Sheet1View(title: "Level Four", hints: Level.all[3].description)
                } else if workspace.currentLevelIndex == 4 {
                    Sheet1View(title: "Level Five", hints: Level.all[4].description)
                }
            })
            .sheet(isPresented: $workspace.isShowingCompleteSheet, content: {
                if workspace.currentLevelIndex == 0 {
                    Congrats1View(title: "⭐️ Level One Complete")
                        .environmentObject(workspace)
                } else if workspace.currentLevelIndex == 1 {
                    Congrats1View(title: "⭐️ Level Two Complete")
                        .environmentObject(workspace)
                } else if workspace.currentLevelIndex == 2 {
                    Congrats1View(title: "⭐️ Level Three Complete")
                        .environmentObject(workspace)
                } else if workspace.currentLevelIndex == 3 {
                    Congrats1View(title: "⭐️ Level Four Complete")
                        .environmentObject(workspace)
                } else if workspace.currentLevelIndex == 4 {
                    Congrats1View(title: "⭐️ Level Five Complete", lastLevel: true)
                }
            })
            .sheet(isPresented: $workspace.isShowingInfiniteLoopError, content: {
                Text("Infinite loop detected!\nThis is caused by functions calling themselves, causing an infinite amount of iterations.\nTry breaking up that function so that it doesn't call itself!")
                    .padding()
            })
            // task runs after layout is computed, so geo will have the correct size.
            .task {
                setupBlocks(geo)
            }
//            .onAppear {
//                setupBlocks(geo)
//            }
        }
    }
    
    func setupBlocks(_ geo: GeometryProxy) {
        let play = PlayBlock(
            position: CGPoint(x: geo.size.width / 2 - 75, y: geo.size.height / 2 - 50)
        )
        workspace.rightPlayBlockID = play.id
        
        let note1 = NoteBlock(
            position: CGPoint(x: geo.size.width / 2 + 150, y: geo.size.height / 2 + 75),
            note: Note(duration: .quarter, pitch: .c4)
        )
        
        let note2 = NoteBlock(
            position: CGPoint(x: geo.size.width / 2, y: geo.size.height / 2 + 250),
            note: Note(duration: .quarter, pitch: .d4)
        )
        
        print(note1.id)
        print(note2.id)
        
        workspace.addBlock(play)
        workspace.addBlock(note1)
        workspace.addBlock(note2)
    }
}

//#Preview {
//    BlocklyWorkspaceView()
//}
