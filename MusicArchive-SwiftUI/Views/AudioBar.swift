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
                if self.player.state == .playing {
                    self.player.state = .paused
                } else {
                    self.player.state = .playing
                }
            }) {
                Text(player.state.rawValue)
            }
            Text(player.songObserver.song?.name ?? "n/a")
        }
    }
}

struct AudioBarPreview: PreviewProvider {
    static var previews: some View {
        AudioBar()
    }
}
