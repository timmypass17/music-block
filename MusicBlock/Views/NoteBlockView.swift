//
//  BlockView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/23/26.
//

import SwiftUI

struct NoteBlockView: View {
    @EnvironmentObject var workspace: BlockWorkspace
    let blockID: UUID
    
    @State private var dragOffset: CGSize = .zero
    @State var isExpanded = false
    
    var noteBlock: NoteBlock {
        workspace.blocks[blockID] as! NoteBlock
    }
    
    var body: some View {
        BlocklyBlockShape()
            .foregroundStyle(.blue)
            .frame(width: 200, height: 60)
//            .border(.red)
            .overlay {
                HStack {
                    Text("play")
                        .foregroundStyle(.white)
//                        .border(.red)
                    DropdownMenu(isExpanded: $isExpanded, blockID: blockID, dropDownAlignment: .trailing, fromTop: false, options: [
                        DropdownOption(duration: .whole, action: { print("Details") }),
                        DropdownOption(duration: .half, action: { print("Details") }),
                        DropdownOption(duration: .quarter, action: { print("Details") }),
                        DropdownOption(duration: .eighth, action: { print("Details") }),
                        DropdownOption(duration: .sixteenth, action: { print("Details") })
                    ])
//                    .border(.red)

                    Spacer()

                    Text("note")
                        .foregroundStyle(.white)
//                        .border(.red)


                    DropdownNoteMenu(blockID: blockID, dropDownAlignment: .trailing, fromTop: false)
//                        .border(.red)

                }
                .padding()
                .frame(maxWidth: .infinity)
//                .border(.orange)
            }
            .position(noteBlock.position)
            .brightness(
                workspace.noteBlockIDBeingPlayed == noteBlock.id ||
                workspace.otherNoteBlockIDBeingPlayed == noteBlock.id
                ? 0.25
                : 0
            )
//            .opacity(workspace.noteBlockIDBeingPlayed == noteBlock.id || workspace.otherNoteBlockIDBeingPlayed == noteBlock.id ? 0.3 :  1)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        workspace.disconnect(blockID)
                        workspace.moveStack(
                            from: blockID,
                            to: value.location
                        )
                        workspace.selectedBlockID = blockID
                    }
                    .onEnded { _ in
                        workspace.trySnap(blockID)
                    }
            )
//            .onChange(of: noteBlock.position) { oldValue, newValue in
//                isExpanded = false
//            }
    }
}

struct BlocklyBlockShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r: CGFloat = 12 // outer corner radius
        
        path.move(to: CGPoint(x: rect.minX + r, y: rect.minY))
        
        // Top edge + tab
        path.addLine(to: CGPoint(x: rect.minX + 20, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + 30, y: rect.minY + 8))
        path.addLine(to: CGPoint(x: rect.minX + 40, y: rect.minY + 8))
        path.addLine(to: CGPoint(x: rect.minX + 50, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        
        // Top-right corner
        path.addArc(
            center: CGPoint(x: rect.maxX - r, y: rect.minY + r),
            radius: r,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        // Right side
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))
        
        // Bottom-right corner
        path.addArc(
            center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
            radius: r,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        
        // Bottom tab
        path.addLine(to: CGPoint(x: rect.minX + 50, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + 40, y: rect.maxY + 8))
        path.addLine(to: CGPoint(x: rect.minX + 30, y: rect.maxY + 8))
        path.addLine(to: CGPoint(x: rect.minX + 20, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))
        
        // Bottom-left corner
        path.addArc(
            center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
            radius: r,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        // Left side
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        
        // Top-left corner
        path.addArc(
            center: CGPoint(x: rect.minX + r, y: rect.minY + r),
            radius: r,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        path.closeSubpath()
        
        return path
    }
}
