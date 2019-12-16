//
//  AudioPlayer.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/15/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

enum PlayState: String {
    case playing
    case paused
    case stopped
}

class AudioPlayer: ObservableObject {
    static let shared = AudioPlayer()
    @Published var songObserver: SongObserver = SongObserver()
    @Published var state: PlayState = .stopped
    
    func play(song: Song) {
        state = .playing
        songObserver.song = song
    }
    
    func pause() {
        state = .paused
    }
    
    func stop() {
        state = .stopped
    }
}
