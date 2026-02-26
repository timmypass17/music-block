//
//  FunctionInstanceBlockView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/25/26.
//

import SwiftUI


struct FunctionInstanceBlockView: View {
    @EnvironmentObject var workspace: BlockWorkspace
    let blockID: UUID
        
    var functionInstanceBlock: FunctionInstanceBlock {
        return workspace.blocks[blockID] as! FunctionInstanceBlock
    }
    
    var body: some View {
        BlocklyBlockShape()
            .foregroundStyle(.purple)
            .frame(width: 200, height: 60)
//            .border(.red)
            .overlay {
                HStack {
                    Text("play")
                        .foregroundStyle(.white)
                    Text(workspace.getFunctionName(functionID: functionInstanceBlock.functionBlockID ?? UUID()))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.regularMaterial)
                        )
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .position(functionInstanceBlock.position)
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
//    FunctionInstanceBlockView()
//}
