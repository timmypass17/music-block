//
//  BlockView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/23/26.
//

import SwiftUI

struct BlockView: View {
    @State var position: CGPoint
    @State var selectedDuration: NoteDuration = .quarter
    @State var selectedNote: Note = .c4
//    @Binding var showNotePicker: Bool
    
    var body: some View {
        BlocklyBlockShape()
            .foregroundStyle(.blue)
            .frame(width: 200, height: 60)
            .border(.red)
            .overlay {
                HStack {
                    Text("play")
                        .foregroundStyle(.white)
//                        .border(.red)
                    DropdownMenu(selectedNote: $selectedDuration, dropDownAlignment: .trailing, fromTop: false, options: [
                        DropdownOption(note: .whole, action: { print("Details") }),
                        DropdownOption(note: .half, action: { print("Details") }),
                        DropdownOption(note: .quarter, action: { print("Details") }),
                        DropdownOption(note: .eight, action: { print("Details") }),
                        DropdownOption(note: .sixteenth, action: { print("Details") })
                    ])
//                    .border(.red)

                    Spacer()
                    
                    Text("note")
                        .foregroundStyle(.white)
//                        .border(.red)

                    
                    DropdownNoteMenu(selectedDuration: $selectedDuration, selectedNote: $selectedNote, dropDownAlignment: .trailing, fromTop: false)
//                        .border(.red)

                }
                .padding()
                .frame(maxWidth: .infinity)
//                .border(.orange)
            }
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        position = value.location
                    }
            )
    }
}

//#Preview {
//    BlockView(position: CGPoint(x: 100, y: 100))
//}

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
