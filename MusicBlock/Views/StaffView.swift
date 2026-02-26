//
//  StaffView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import SwiftUI

struct StaffView: View {
//    @Binding var baseOffset: Double // -18
//    @Binding var spacing: Double    // 10
    @EnvironmentObject var workspace: BlockWorkspace
    var barHeight: Double = 62
    var barYOffset: Double = 61
    let song: [Note] = Song.song1
    let userNotes: [Note]
    let visibleNotes: [Bool]
    
    let noteSpacing: CGFloat = 70
    let lineSpacing: CGFloat = 20
    
//    let beatsPerMeasure = 4
    
    var body: some View {
        ZStack {
            
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
                    ForEach(song.indices, id: \.self) { index in
                        let note = song[index]

                        Image(note.duration.iconName)
                            .resizable()
                            .opacity(0.4)
                            .scaledToFit()
                            .frame(width: 33, height: 71)
                            .position(
//                                x: CGFloat(index) * noteSpacing + 100,
                                x: xNoteOffset(song, index),   // 100 is inital base offset
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
                            .position(
                                x: xNoteOffset(song, index),
                                y: yForPitch(note.pitch)
                            )
                            .id(note.id)
                    }
                }
                .frame(width: timelineWidth(), height: 120)
                .scrollTargetLayout()
                .border(.orange)
            }
            .frame(width: 700, height: 120)
            .scrollPosition($workspace.scrollPosition)
            .onChange(of: workspace.scrollPosition) { oldValue, newValue in
                // Observe changes in the scroll position
                print("Scrolled to item ID: \(newValue)")
            }
        }
        .frame(width: 700, height: 120)
        .border(.blue)
    }
    
    func timelineWidth() -> CGFloat {
        CGFloat(song.count) * noteSpacing + 200
    }
    
    func getUserNoteColor(_ index: Int) -> Color {
        guard index < song.count else { return .red }
        
        if song[index] == userNotes[index] {
            return .black
        } else {
            return .red
        }
    }
    
//    func xNoteOffset(_ index: Int) -> CGFloat {
//        let sixteenthSpacing: CGFloat = 17
//        let eighthSpacing: CGFloat = sixteenthSpacing * 2
//        let quarterSpacing: CGFloat = sixteenthSpacing * 4
//        let halfSpacing: CGFloat = sixteenthSpacing * 8
//        let wholeSpacing: CGFloat = sixteenthSpacing * 16
//        
//        var totalXOffset: CGFloat = 0
//        var beats = 0.0
//
//        // Get previous notes and count offset
//        var j = 0
//        while j < index {
//            let note = song[j]
//            switch note.duration {
//            case .whole:
//                totalXOffset += wholeSpacing
//            case .half:
//                totalXOffset += halfSpacing
//            case .quarter:
//                totalXOffset += quarterSpacing
//            case .eighth:
//                totalXOffset += eighthSpacing
//            case .sixteenth:
//                totalXOffset += sixteenthSpacing
//            }
//            
//            // Add extra padding after each measure
//            if beats.truncatingRemainder(dividingBy: Double(beatsPerMeasure)) == 0 {
//                totalXOffset += 10
//            }
//            
//            beats += note.duration.rawValue
//            j += 1
//        }
//        
//        return totalXOffset + 110
//    }
    
    func yForPitch(_ pitch: Pitch) -> CGFloat {
        let baseOffset: Double = -27.13    // where a4 is
        let spacing: Double = 7.9578 // vertical offset between each pitch
//        print("\(pitch): \((110 - (pitch.rawValue * spacing))) \(pitch.rawValue) \(baseOffset + (130 - (pitch.rawValue * spacing)))")
        return CGFloat(baseOffset + (110.0 - (Double(pitch.rawValue) * spacing)))
    }
    
    func measurePositions() -> [CGFloat] {
        let beatsPerMeasure = 4
        var beats = 0.0
        var measureX: [CGFloat] = []
                
        for index in song.indices {
            let note = song[index]
            
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
