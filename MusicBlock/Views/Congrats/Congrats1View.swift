//
//  Congrats1View.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/26/26.
//

import SwiftUI

struct Congrats1View: View {
    @EnvironmentObject var workspace: BlockWorkspace

    var body: some View {
        VStack {
            Text("Level Complete")
                .font(.title)
            Button {
                workspace.isShowingCompleteSheet = false
                workspace.currentLevelIndex = min(workspace.currentLevelIndex + 1, workspace.levels.count)
                workspace.levels[workspace.currentLevelIndex].available = true
                workspace.isShowingHintSheet = true
            } label: {
                Text("Next")
            }

        }
        .padding()
    }
}

#Preview {
    Congrats1View()
}
