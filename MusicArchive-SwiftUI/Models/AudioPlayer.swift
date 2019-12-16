//
//  AudioPlayer.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/15/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

enum PlayState: String {
    case playing
    case paused
    case stopped
    
    func image() -> Image {
        switch self {
        case .playing:
            return Image(systemName: "pause.circle")
        case .paused:
            return Image(systemName: "play.circle")
        case .stopped:
            return Image(systemName: "play.circle")
        }
    }
}

class AudioPlayer: ObservableObject {
    static let shared = AudioPlayer()
    @Published var songObserver: SongObserver = SongObserver()
    @Published var state: PlayState = .stopped
    private var _player: AVAudioPlayer?
    
    func play(song: Song) {
        state = .playing
        songObserver.song = song
        _player = try? AVAudioPlayer(contentsOf: URL(string: song.url!)!)
        _player?.play()
    }
    
    func pause() {
        state = .paused
        _player?.pause()
    }
    
    func stop() {
        state = .stopped
        _player?.stop()
    }
}
