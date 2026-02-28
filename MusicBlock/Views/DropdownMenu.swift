//
//  DropdownMenu.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/23/26.
//

import SwiftUI

struct DropdownMenu: View {
    @EnvironmentObject var workspace: BlockWorkspace
//    @Binding var selectedNote: NoteDuration
    @Binding var isExpanded: Bool
    @State var menuWidth: CGFloat = 0
    let blockID: UUID
    var icon = "ellipsis"
    var dropDownAlignment: DropdownAlignent = .center
    var iconOnly: Bool = true
    var fromTop: Bool = false
    
    var noteBlock: NoteBlock {
        get {
            return workspace.blocks[blockID] as! NoteBlock
        }
        set {
            workspace.blocks[blockID] = newValue
        }
    }
    
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
    
    let options: [DropdownOption]
    
    var body: some View {
        ZStack {
            Button {
                isExpanded.toggle()
                workspace.selectedBlockID = blockID
            } label: {
                Image(noteBlock.note.duration.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(4)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
            }
            .tint(.primary)
            .frame(height: 50)
            .overlay(alignment: fromTop ? .bottom : .top) {
                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(options) { option in
                            HStack(spacing: 8) {
                                Image(option.duration.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
//                            .foregroundStyle(option.color)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                if var block = workspace.blocks[blockID] as? NoteBlock {
                                    block.note.duration = option.duration
                                    workspace.blocks[blockID] = block
                                    workspace.selectedBlockID = blockID
                                }
                                option.action()
                                withAnimation {
                                    isExpanded = false
                                }
                            }
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
//                    .zIndex(Double(noteBlock.note.index))
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
//        .frame(maxWidth: .infinity, alignment: frameAlignment)
//        .animation(.smooth, value: isExpanded)
    }
}

//#Preview {
//    DropdownMenu(dropDownAlignment: .trailing, fromTop: false, options: [
//    ])
//}

struct DropdownOption: Identifiable {
    let id = UUID()
    var duration: NoteDuration
    var action: () -> Void
}

enum DropdownAlignent {
    case leading, center, trailing
}

enum NoteDuration: Double, CaseIterable {
    case whole = 4
    case half = 2
    case quarter = 1     // 1 beat
    case eighth = 0.5
    case sixteenth = 0.25
    
    var iconName: String {
        switch self {
        case .whole:
            return "whole"
        case .half:
            return "half"
        case .quarter:
            return "quarter"
        case .eighth:
            return "eight"
        case .sixteenth:
            return "sixteenth"
        }
    }
}
