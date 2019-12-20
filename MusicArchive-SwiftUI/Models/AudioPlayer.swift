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
import MediaPlayer
import Combine

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

class SongPlayerItem: AVPlayerItem {
    var song: Song?
    
    convenience init(url: URL, song: Song) {
        self.init(url: url)
        self.song = song
    }
    
}

class AudioPlayer: NSObject, ObservableObject {
    static let shared = AudioPlayer()
    @Published var currentSong: Song?
    @Published var state: PlayState = .stopped
    private var _player = AVQueuePlayer()
    private var previousSongPlayerItems = [SongPlayerItem]()
    private var itemSubscriber: AnyCancellable!
    private var timeControlSubscriber: AnyCancellable!
    private var trackTimeSubscriber: AnyCancellable!
    
    override init() {
        super.init()
        
        setupListeners()
        setupAudioSession()
    }
    
    private func setupListeners() {
        // Set up subscribers
        self.trackTimeSubscriber = _player.publisher(for: \.currentItem)
            .filter({ $0 != nil })
            .flatMap({ item -> NSObject.KeyValueObservingPublisher<AVPlayerItem, CMTimebase?> in
                let publisher = item!.publisher(for: \.timebase)
                return publisher
            }).sink(receiveValue: { time in
                // TODO in app slider or something
            })
                
        self.itemSubscriber = _player.publisher(for: \.currentItem)
            .sink(receiveValue: { [weak self] item in
                guard let songItem = item as? SongPlayerItem,
                    let song = songItem.song else {
                        return
                }
                
                self?.previousSongPlayerItems.append(songItem, max: 40)
                self?.currentSong = song
                self?.updateInfoCenter(song: song, duration: songItem.duration)
            })
        
        self.timeControlSubscriber = _player.publisher(for: \.timeControlStatus)
            .sink(receiveValue: { timeControlStatus in
                // TODO Actually update play icon state based on the player control status
                if timeControlStatus == .playing {
                    MPNowPlayingInfoCenter.default().playbackState = .playing
                } else if timeControlStatus == .paused {
                    MPNowPlayingInfoCenter.default().playbackState = .paused
                } else {
                    MPNowPlayingInfoCenter.default().playbackState = .stopped
                }
            })
    }
    
    private func setupAudioSession() {
        // Configure default audio session and remote command setup
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .init(rawValue: 0))
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(remotePlay))
        commandCenter.pauseCommand.addTarget(self, action: #selector(remotePause))
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(remotePlayNext))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(remotePlayPrevious))
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(remoteChangePlaybackPosition(event:)))
    }
    
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
        currentSong = song
        if let currentItem = _player.currentItem {
            _player.remove(currentItem)
        }
        insertNext(song: song)
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
    
    @objc func remotePlayPrevious() -> MPRemoteCommandHandlerStatus {
        // TODO
        return MPRemoteCommandHandlerStatus.success
    }
    
    @objc func remotePlayNext() -> MPRemoteCommandHandlerStatus {
        playNext()
        return MPRemoteCommandHandlerStatus.success
    }
    
    @objc func remotePlay() -> MPRemoteCommandHandlerStatus {
        play()
        return MPRemoteCommandHandlerStatus.success
    }
    
    @objc func remotePause() -> MPRemoteCommandHandlerStatus {
        pause()
        return MPRemoteCommandHandlerStatus.success
    }
    
    @objc func remoteChangePlaybackPosition(event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        // TODO
        return MPRemoteCommandHandlerStatus.success
    }
    
    private func insertNext(song: Song) {
        guard let urlString = song.url,
            let url = URL(string: urlString) else {
                return
        }
        let playerItem = SongPlayerItem(url: url, song: song)
        _player.insert(playerItem, after: _player.currentItem)
    }
    
    // Append song to the queue
    func playLater(song: Song) {
        guard let urlString = song.url,
            let url = URL(string: urlString) else { return }
        let playerItem = SongPlayerItem(url: url, song: song)
        _player.insert(playerItem, after: nil)
    }
    
    // Pauses the current track
    @objc func pause() {
        state = .paused
        _player.pause()
    }
    
    // Stops the current track
    func stop() {
        state = .stopped
        _player.seek(to: .zero)
        _player.pause()
    }
    
    func queue(songs: [Song]) {
        songs.forEach({ playLater(song: $0) })
    }
    
    // Clears all the songs in the queue
    func clearQueue() {
        _player.removeAllItems()
    }
    
    private func updateInfoCenter(song: Song, duration: CMTime) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = song.name
        nowPlayingInfo[MPMediaItemPropertyArtist] = "-"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "-"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
}
