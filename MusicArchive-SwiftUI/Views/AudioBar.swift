//
//  AudioBar.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation
import SwiftUI

struct AudioBar: View {
    @EnvironmentObject var player: AudioPlayer
    
    var body: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: "backward.fill").resizable().frame(width: 20, height: 20, alignment: .center)
            }.padding(.all, 10)
            Button(action: {
                if self.player.state == .playing {
                    self.player.state = .paused
                } else {
                    self.player.state = .playing
                }
            }) {
                player.state.image().resizable().frame(width: 40, height: 40, alignment: .center)
                }.padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            Button(action: {
                
            }) {
                Image(systemName: "forward.fill").resizable().frame(width: 20, height: 20, alignment: .center)
            }.padding(.all, 10)
            Text(player.songObserver.song?.name ?? "n/a")
            Spacer()
        }
    }
}

struct AudioBarPreview: PreviewProvider {
    static var previews: some View {
        AudioBar()
    }
}
