// Copyright (c) 2020 Joshua Escribano-Fontanet

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
            Text(player.currentSong?.name ?? "")
            Spacer()
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct AudioBarPreview: PreviewProvider {
    static var previews: some View {
        AudioBar()
    }
}
