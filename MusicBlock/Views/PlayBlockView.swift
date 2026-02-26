//
//  PlayBlockView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import SwiftUI

struct PlayBlockView: View {
    @EnvironmentObject var workspace: BlockWorkspace
    let blockID: UUID
    var playBlock: PlayBlock {
        workspace.blocks[blockID] as! PlayBlock
    }
    
    var body: some View {
        PlayBlockShape()
            .foregroundStyle(.orange)
            .frame(width: 200, height: 60)
            .border(.red)
            .overlay {
                HStack {
                    Text("when")
                        .foregroundStyle(.white)
                    Image(systemName: "play.fill")
                        .foregroundStyle(.green)
                    Text("clicked")
                        .foregroundStyle(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
//                .border(.orange)
            }
            .position(playBlock.position)
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
    }
}

//#Preview {
//    PlayBlockView()
//}

struct PlayBlockShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r: CGFloat = 12 // outer corner radius
        
        path.move(to: CGPoint(x: rect.minX + r, y: rect.minY))
        
        // Top edge + tab
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
