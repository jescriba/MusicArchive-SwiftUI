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
    private var _player = AVQueuePlayer()
    
    // Toggles the play state. If paused/stopped will trigger play otherwise will trigger paused
    func togglePlayState() {
        if state == .playing {
            pause()
        } else {
            play()
        }
    }
    
    // Plays given song now if specified - otherwise plays currentTrack in queue
    func play(song songO: Song? = nil) {
        state = .playing
        guard let song = songO else {
            _player.play()
            return
        }
        songObserver.song = song
        insertNext(song: song)
        if let currentItem = _player.currentItem {
            _player.remove(currentItem)
        }
        _player.play()
    }
    
    // Adds song to play next if specified otherwise plays next song in the queue now.
    func playNext(song songO: Song? = nil) {
        guard let song = songO else {
            _player.advanceToNextItem()
            return
        }
        
        insertNext(song: song)
    }
    
    // Plays the previous song that was in the queue. 
    func playPrevious() {
        // TODONOW
    }
    
    private func insertNext(song: Song) {
        guard let urlString = song.url,
            let url = URL(string: urlString) else {
                return
        }
        let playerItem = AVPlayerItem(url: url)
        _player.insert(playerItem, after: _player.currentItem)
    }
    
    // Append song to the queue
    func playLater(song: Song) {
        guard let urlString = song.url,
            let url = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: url)
        _player.insert(playerItem, after: nil)
    }
    
    // Pauses the current track
    func pause() {
        state = .paused
        _player.pause()
    }
    
    // Stops the current track
    func stop() {
        state = .stopped
        _player.seek(to: .zero)
        _player.pause()
    }
    
    // Clears all the songs in the queue
    func clearQueue() {
        _player.removeAllItems()
    }
    
}
