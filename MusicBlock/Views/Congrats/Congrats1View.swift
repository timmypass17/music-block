//
//  Congrats1View.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/26/26.
//

import SwiftUI

struct Congrats1View: View {
    @EnvironmentObject var workspace: BlockWorkspace
    var title: String
    var lastLevel: Bool = false
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            
            if lastLevel {
                Text("Thanks for playing!")
            } else {
                Button {
                    workspace.isShowingCompleteSheet = false
                    workspace.isShowingHintSheet = true
                } label: {
                    Text("Next Level")
                }
                .buttonStyle(.borderedProminent)
            }

        }
        .padding()
    }
}

//#Preview {
//    Congrats1View()
//}
