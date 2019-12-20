//
//  ContentObserver.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/15/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

class ContentObserver: ObservableObject {
    @Published var content = [Content]()
    lazy var selectionAction: (_: Content) -> Void = { selectedContent in
        switch self.content.first {
        case is Artist:
            break
        case is Song:
            guard let songs = self.content as? [Song],
                let song = selectedContent as? Song,
                let index = songs.firstIndex(where: { $0 == song }) else {
                    return
            }
            AudioPlayer.shared.play(song: song)
            DispatchQueue.global().async {
                AudioPlayer.shared.queue(songs: Array(songs.dropFirst(index + 1)))
            }
        case is Album:
            guard let albums = self.content as? [Album],
                let album = selectedContent as? Album else {
                    return
            }
            self.content = album.songs
        case is Playlist:
            guard let playlists = self.content as? [Playlist],
                let playlist = selectedContent as? Playlist else {
                    return
            }
            self.content = playlist.songs
            break
        default:
            break
        }
    }

}
