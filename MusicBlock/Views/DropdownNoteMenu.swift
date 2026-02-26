//
//  DropdownNoteMenu.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/23/26.
//

import SwiftUI

struct DropdownNoteMenu: View {
    @EnvironmentObject var workspace: BlockWorkspace

    let blockID: UUID

    var noteBlock: NoteBlock {
        get {
            return workspace.blocks[blockID] as! NoteBlock
        }
        set {
            workspace.blocks[blockID] = newValue
        }
    }
    
//    @Binding var selectedDuration: NoteDuration
//    @Binding var selectedNote: Note
    
    @State var isExpanded = false
    @State var menuWidth: CGFloat = 0
    var icon = "ellipsis"
    var dropDownAlignment: DropdownAlignent = .center
    var iconOnly: Bool = true
    var fromTop: Bool = false
    
    var transitionAnchor: UnitPoint {
        if fromTop {
            return dropDownAlignment == .leading ? .leading : dropDownAlignment == .center ? .center : .trailing
        } else {
            return dropDownAlignment == .leading ? .topLeading : dropDownAlignment == .center ? .top : .topTrailing
        }
    }
    
    var frameAlignment: Alignment {
        switch dropDownAlignment {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }
        
    var body: some View {
        ZStack {
            Button {
                isExpanded.toggle()
                workspace.selectedBlockID = blockID
            } label: {
                Text(noteBlock.note.pitch.description)
                    .frame(width: 30, height: 30)
                    .padding(4)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
            }
            .tint(.primary)
            .frame(height: 50)
            .overlay(alignment: fromTop ? .bottom : .top) {
                if isExpanded {
                    VStack(alignment: .center, spacing: 8) {
                        Button {
                            if var block = workspace.blocks[blockID] as? NoteBlock {
                                let index = (block.note.pitch.index + 1) % Pitch.allCases.count
                                let selectedNote = Pitch(rawValue: index)!
                                block.note.pitch = selectedNote
                                workspace.blocks[blockID] = block
                                workspace.selectedBlockID = blockID
                            }
                        } label: {
                            Image(systemName: "chevron.up")
                        }

                        SpriteView(
                            imageName: "notes",
                            index: noteBlock.note.pitch.index,
                            spriteWidth: 490 / 13,
                            spriteHeight: 109
                        )
//                        .offset(x: (490/2))
                        
                        Button {
                            if var block = workspace.blocks[blockID] as? NoteBlock {
                                let index = (Pitch.allCases.count + block.note.pitch.index - 1) % Pitch.allCases.count
                                let selectedNote = Pitch(rawValue: index)!
                                block.note.pitch = selectedNote
                                workspace.blocks[blockID] = block
                                workspace.selectedBlockID = blockID
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
                    )
                    .offset(y: fromTop ? -50 : 50)
                    .fixedSize() // w/o swiftUI might try to compress layout
//                    .transition(
//                        .scale(scale: 0, anchor: transitionAnchor)
//                        .combined(with: .opacity)
//                        .combined(with: .offset(y: 40))
//                    )
//                    .background(
//                        GeometryReader { proxy in
//                            Color.clear
//                                .onAppear {
//                                    // We need to capture width or else content will be cut off if show on edge of screen
//                                    menuWidth = proxy.size.width
//                                }
//                        }
//                    )
                }
            }
        }
        .frame(width: 30, height: 30)
//        .frame(width: menuWidth)
//        .frame(maxWidth: .infinity, alignment: frameAlignment)
        .animation(.smooth, value: isExpanded)
    }
}

//#Preview {
//    DropdownNoteMenu()
//}

enum Pitch: Int, CaseIterable, CustomStringConvertible {
    case c3, d3, e3, f3, g3, a3, b3, c4, d4, e4, f4, g4, a4
    
    var index: Int {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .c3: "C3"
        case .d3: "D3"
        case .e3: "E3"
        case .f3: "F3"
        case .g3: "G3"
        case .a3: "A3"
        case .b3: "B3"
        case .c4: "C4"
        case .d4: "D4"
        case .e4: "E4"
        case .f4: "F4"
        case .g4: "G4"
        case .a4: "A4"
        }
    }
}

struct SpriteView: View {
    let imageName: String
    let index: Int        // which image you want to show
    let spriteWidth: CGFloat    // single sprite
    let spriteHeight: CGFloat

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: spriteWidth * totalSprites, height: spriteHeight) // load entire sprite sheet
//            .border(.orange)
            .frame(width: spriteWidth, height: spriteHeight, alignment: .leading)
            .offset(x: -CGFloat(index) * spriteWidth)
        //            .border(.blue)
            .clipped()
    }

    var totalSprites: CGFloat {
        13 // number of images inside the sprite sheet
    }
}
