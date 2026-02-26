//
//  DropdownFunctionMenu.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/25/26.
//

import SwiftUI

struct DropdownFunctionMenu: View {
    @EnvironmentObject var workspace: BlockWorkspace
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
    
    let options: [String]
    
    var body: some View {
        ZStack {
            Button {
                isExpanded.toggle()
            } label: {
                HStack {
                    Image(systemName: "cube.fill")
                    Text("Function Block")
                }
            }
            .tint(.primary)
            .frame(height: 50)
            .overlay(alignment: fromTop ? .bottom : .top) {
                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(options, id: \.self) { option in
                            HStack(spacing: 8) {
                                Text(option)
                            }
                            .padding(.vertical, 5)
                            .onTapGesture {
                                if option == "New Block" {
                                    
                                }
//                                if var block = workspace.blocks[blockID] as? NoteBlock {
//                                    block.note.duration = option.duration
//                                    workspace.blocks[blockID] = block
//                                    workspace.selectedBlockID = blockID
//                                }
//                                option.action()
//                                withAnimation {
//                                    isExpanded = false
//                                }
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
                }
            }
        }
//        .frame(width: 30, height: 30)
        .animation(.smooth, value: isExpanded)
    }
}

//#Preview {
//    DropdownFunctionMenu()
//}
