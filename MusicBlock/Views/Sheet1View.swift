//
//  Sheet1View.swift
//  MusicBlock
//
//  Created by Timmy Nguyen on 2/26/26.
//

import SwiftUI

struct Sheet1View: View {
    let title: String
    let hints: String
    var imageName: String? = nil
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white
                VStack {
                    Text(title)
                        .font(.system(size: 40))
                    Text(.init(hints))  // enables markdown for bold and italicize
                        .padding(.vertical)
                                    
                    if let imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: geo.size.height * 0.4)
                    }
                }
                .padding(32)
            }
        }
    }
}

//#Preview {
//    Sheet1View()
//}
