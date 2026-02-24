//
//  DropdownMenu.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/23/26.
//

import SwiftUI

struct DropdownMenu: View {
    @Binding var selectedNote: NoteDuration
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
    
    let options: [DropdownOption]
    
    var body: some View {
        ZStack {
            Button {
                isExpanded.toggle()
            } label: {
                Image(selectedNote.iconName)
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
                                Image(option.note.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
//                            .foregroundStyle(option.color)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                selectedNote = option.note
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
        .animation(.smooth, value: isExpanded)
    }
}

//#Preview {
//    DropdownMenu(dropDownAlignment: .trailing, fromTop: false, options: [
//    ])
//}

struct DropdownOption: Identifiable {
    let id = UUID()
    var note: NoteDuration
    var action: () -> Void
}

enum DropdownAlignent {
    case leading, center, trailing
}

enum NoteDuration: String, CaseIterable {
    case whole, half, quarter, eight, sixteenth
    
    var iconName: String {
        return self.rawValue
    }
}
