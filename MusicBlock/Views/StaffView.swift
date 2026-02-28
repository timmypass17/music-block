//
//  StaffView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import SwiftUI

struct StaffView: View {
//    @Binding var baseOffset: Double
//    @Binding var spacing: Double
//    @Binding var barYOffset: Double
    
    /*@Binding*/ var slashWidth: Double = 35.826
    /*@Binding*/ var slashXOffset: Double = 11.855
    /*@Binding*/ var slashYOffset: Double = 70.595
    /*@Binding*/ var slashSpacing: Double = 4.992
    
    @EnvironmentObject var workspace: BlockWorkspace
    var barHeight: Double = 62
    
    var barYOffset: Double = 60.80
    let notes: [Note]
    let userNotes: [Note]
    let visibleNotes: [Bool]
    
    let noteSpacing: CGFloat = 70
    let lineSpacing: CGFloat = 20
    @Binding var scrollPosition: ScrollPosition

//    let beatsPerMeasure = 4
    
    var body: some View {
        ZStack {
            Color.white
            
            Image("stave")
                .resizable()
                .frame(width: 700, height: 120)
            
            ScrollView(.horizontal, showsIndicators: true) {
                ZStack(alignment: .topLeading) {

                    // Measure lines
                    ForEach(measurePositions(), id: \.self) { x in
                        Rectangle()
                            .frame(width: 2, height: barHeight)
                            .position(x: x, y: barYOffset)
                    }

                    // Song notes
                    ForEach(notes.indices, id: \.self) { index in
                        let note = notes[index]

                        Image(note.duration.iconName)
                            .resizable()
                            .opacity(0.4)
                            .scaledToFit()
                            .frame(width: 33, height: 71)
                            .background {
                                VStack(spacing: slashSpacing) {
                                    Rectangle()
                                        .fill(.black.opacity(0.4))   // blue
                                        .frame(width: slashWidth, height: 3)
                                        .opacity(note.pitch == .a4 || note.pitch == .c5 || note.pitch == .c3 ? 1 : 0)
                                    Rectangle()
                                        .fill(.black.opacity(0.4)) // orange
                                        .frame(width: slashWidth, height: 3)
                                        .opacity(note.pitch == .b4 ? 1 : 0)
                                    Rectangle()
                                        .fill(.black.opacity(0.4)) // green
                                        .frame(width: slashWidth, height: 3)
                                        .opacity(note.pitch == .c5 ? 1 : 0)
                                }
                                .position(x: slashXOffset, y: slashYOffset)
                            }
                            .position(
                                x: xNoteOffset(notes, index),
                                y: yForPitch(note.pitch)
                            )
                    }

                    // User notes
                    ForEach(userNotes.indices, id: \.self) { index in
                        let note = userNotes[index]

                        Image(note.duration.iconName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(getUserNoteColor(index))
                            .scaleEffect(visibleNotes[index] ? 1 : 0.7)
                            .opacity(visibleNotes[index] ? 1 : 0)
                            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: visibleNotes[index])
                            .offset(y: visibleNotes[index] ? 0 : -20)
                            .scaledToFit()
                            .frame(width: 33, height: 71)
                            .background {
                                VStack(spacing: slashSpacing) {
                                    Rectangle()
                                        .fill(getUserNoteColor(index))   // blue
                                        .frame(width: slashWidth, height: 3)
                                        .opacity(note.pitch == .a4 || note.pitch == .c5 || note.pitch == .c3 ? 1 : 0)
                                    Rectangle()
                                        .fill(getUserNoteColor(index)) // orange
                                        .frame(width: slashWidth, height: 3)
                                        .opacity(note.pitch == .b4 ? 1 : 0)
                                    Rectangle()
                                        .fill(getUserNoteColor(index)) // green
                                        .frame(width: slashWidth, height: 3)
                                        .opacity(note.pitch == .c5 ? 1 : 0)
                                }
                                .scaleEffect(visibleNotes[index] ? 1 : 0.7)
                                .opacity(visibleNotes[index] ? 1 : 0)
                                .animation(.spring(response: 0.25, dampingFraction: 0.6), value: visibleNotes[index])
                                .position(x: slashXOffset, y: slashYOffset)
                            }
                            .position(
                                x: xNoteOffset(userNotes, index),
                                y: yForPitch(note.pitch)
                            )
                            .id(note.id)
                    }
                }
                .frame(width: timelineWidth(), height: 120)
                .scrollTargetLayout()
//                .border(.blue)
            }
            .frame(width: 700, height: 120)
            .scrollClipDisabled()   // allow notes to overflow
            .mask(
                // Manually clip ONLY horizontal axis, allowing vertical overflow
                Rectangle()
                    .padding(.vertical, -200)   // increase vertical clip height
                    .padding(.leading, 45)  // decrease leading clip for clef
            )
//            .border(.green)
            .scrollPosition($scrollPosition)
        }
        .frame(width: 700, height: 120)
//        .border(.black)
    }
    
    func timelineWidth() -> CGFloat {
        // Choose length of song's notes or user's input note
        let staffLength = 700
        return max(xNoteOffset(notes, notes.count - 1), xNoteOffset(userNotes, userNotes.count - 1)) + CGFloat(Double(staffLength) * 0.65) // extra spacing
    }
    
    func getUserNoteColor(_ index: Int) -> Color {
        guard index < notes.count else { return .red }
        
        if notes[index] == userNotes[index] {
            return .black
        } else {
            return .red
        }
    }
    
    func yForPitch(_ pitch: Pitch) -> CGFloat {
        let baseOffset: Double = -26.808
        let spacing: Double = 7.9578 // vertical offset between each pitch

        return CGFloat(baseOffset + (110.0 - (Double(pitch.rawValue) * spacing)))
    }
    
    func measurePositions() -> [CGFloat] {
        let beatsPerMeasure = 4
        var beats = 0.0
        var measureX: [CGFloat] = []
                
        for index in notes.indices {
            let note = notes[index]
            
            // Add bar every 4 beats (1 measure)
            if beats.truncatingRemainder(dividingBy: Double(beatsPerMeasure)) == 0 {
                let x: CGFloat = CGFloat(measureX.count) * (4 * noteSpacing) + 70
                measureX.append(x)
            }
            
            beats += note.duration.rawValue
        }
        
        return measureX
    }
}

//#Preview {
//    StaffView()
//}

func xNoteOffset(_ song: [Note], _ index: Int) -> CGFloat {
    let beatsPerMeasure = 4
    let sixteenthSpacing: CGFloat = 17
    let eighthSpacing: CGFloat = sixteenthSpacing * 2
    let quarterSpacing: CGFloat = sixteenthSpacing * 4
    let halfSpacing: CGFloat = sixteenthSpacing * 8
    let wholeSpacing: CGFloat = sixteenthSpacing * 16
    
    var totalXOffset: CGFloat = 0
    var beats = 0.0

    // Get previous notes and count offset
    var j = 0
    while j < index {
        let note = song[j]
        switch note.duration {
        case .whole:
            totalXOffset += wholeSpacing
        case .half:
            totalXOffset += halfSpacing
        case .quarter:
            totalXOffset += quarterSpacing
        case .eighth:
            totalXOffset += eighthSpacing
        case .sixteenth:
            totalXOffset += sixteenthSpacing
        }
        
        // Add extra padding after each measure
        if beats.truncatingRemainder(dividingBy: Double(beatsPerMeasure)) == 0 {
            totalXOffset += 10
        }
        
        beats += note.duration.rawValue
        j += 1
    }
    
    return totalXOffset + 110
}
