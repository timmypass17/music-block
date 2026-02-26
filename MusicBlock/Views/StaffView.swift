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
    
    var barHeight: Double = 62
    var barYOffset: Double = 61
    let song: [Note] = Song.song1
    let userNotes: [Note]
    let visibleNotes: [Bool]
    
    let noteSpacing: CGFloat = 70
    let lineSpacing: CGFloat = 20
    
    let beatsPerMeasure = 4
    
    var body: some View {
        ZStack {
            
            Image("stave")
                .resizable()
                .frame(width: 700, height: 120)
            
            ScrollView(.horizontal, showsIndicators: false) {
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
                                x: CGFloat(index) * noteSpacing + 100,
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
                                x: CGFloat(index) * noteSpacing + 100,
                                y: yForPitch(note.pitch)
                            )
                    }
                }
                .frame(width: timelineWidth(), height: 120)
                .border(.orange)
            }
            .frame(width: 700, height: 120)
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
    
    func yForPitch(_ pitch: Pitch) -> CGFloat {
        let baseOffset: Double = -27.13    // where a4 is
        let spacing: Double = 7.9578 // vertical offset between each pitch
//        print("\(pitch): \((110 - (pitch.rawValue * spacing))) \(pitch.rawValue) \(baseOffset + (130 - (pitch.rawValue * spacing)))")
        return CGFloat(baseOffset + (110.0 - (Double(pitch.rawValue) * spacing)))
    }
    
    func measurePositions() -> [CGFloat] {
        var beats = 0.0
        var measureX: [CGFloat] = []
        
        for index in song.indices {
            let note = song[index]
            
            if beats.truncatingRemainder(dividingBy: Double(beatsPerMeasure)) == 0 {
                let x = CGFloat(index) * noteSpacing + 70
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
