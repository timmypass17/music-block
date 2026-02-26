//
//  NoteView.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/24/26.
//

import SwiftUI

struct NoteView: View {
    @EnvironmentObject var workspace: BlockWorkspace

    let note: Note
    
    var body: some View {
        Image(note.duration.iconName)
    }
}

//#Preview {
//    NoteView()
//}
