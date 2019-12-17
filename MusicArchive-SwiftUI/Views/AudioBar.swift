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
                self.player.playPrevious()
            }) {
                Image(systemName: "backward.fill").resizable().frame(width: 20, height: 20, alignment: .center)
            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
            Button(action: {
                self.player.togglePlayState()
            }) {
                player.state.image().resizable().frame(width: 40, height: 40, alignment: .center)
                }.padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            Button(action: {
                self.player.playNext()
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
