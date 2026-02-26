//
//  FunctionBlockView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/25/26.
//

import SwiftUI

struct FunctionBlockView: View {
    @EnvironmentObject var workspace: BlockWorkspace
    let blockID: UUID
    
    @State var name: String = ""
    
    var functionBlock: FunctionBlock {
        workspace.blocks[blockID] as! FunctionBlock
    }
    
    var body: some View {
        PlayBlockShape()
            .foregroundStyle(.purple)
            .frame(width: 200, height: 60)
//            .border(.red)
            .overlay {
                HStack {
                    Text("to")
                        .foregroundStyle(.white)
                    TextField("Name", text: $name)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.regularMaterial) 
                        )
                        .onSubmit(of: .text, {
                            print("onSubmit: \(name)")
                            // Create option (if not created yet)
                            if workspace.functionBlockOptions[blockID] == nil {
                                workspace.functionBlockOptions[blockID] = FunctionBlockData(functionBlockID: blockID)
                            }
                            // Update function block name
                            if var functionBlock = workspace.blocks[blockID] as? FunctionBlock {
                                functionBlock.name = name
                                workspace.blocks[blockID] = functionBlock
                            }
                        })
                        .onChange(of: name) {
                            print(name)
                        }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .position(functionBlock.position)
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
//
//#Preview {
//    FunctionBlockView()
//}
