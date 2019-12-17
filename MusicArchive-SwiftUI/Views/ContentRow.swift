//
//  ContentRow.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentRow: View {
    @EnvironmentObject var player: AudioPlayer
    @State var content: Content
    
    var body: some View {
        HStack {
            if content is Song {
                Button(action:  {
                    self.player.play(song: self.content as! Song)
                }) {
                    Text(content.name)
                        .fontWeight(.semibold)
                        .padding(.all, 15)
                }
            } else {
                Button(action:  {
                    
                    //self.player.play(song: self.content as! Song)
                }) {
                    Text(content.name)
                        .fontWeight(.semibold)
                        .padding(.all, 15)
                }
            }
        }
    }
}

struct ContentRowPreview: PreviewProvider {
    static var previews: some View {
        ContentRow(content: Song(name: "Song", description: ""))
    }
}
