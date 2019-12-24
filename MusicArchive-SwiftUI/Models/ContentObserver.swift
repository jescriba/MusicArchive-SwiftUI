//
//  ContentObserver.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/15/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

class ContentObserver: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var contentType: Content.Type = Artist.self
    var currentPage: Int = 1
    let pageSize: Int = 20
    
    @Published var contents = [Content]()
    @Published var parentContent: Content?
    var parentContents: [Content]?
    lazy var selectionAction: (_: Content) -> Void = { selectedContent in
        switch self.contents.first {
        case is Artist:
            guard let artists = self.contents as? [Artist],
                let artist = selectedContent as? Artist else {
                    return
            }
            self.contents = [Song]()
            self.getContent(type: Song.self, parentType: Artist.self)
            self.parentContent = artist
            self.parentContents = artists
        case is Song:
            guard let songs = self.contents as? [Song],
                let song = selectedContent as? Song,
                let index = songs.firstIndex(where: { $0 == song }) else {
                    return
            }
            AudioPlayer.shared.clearQueue()
            AudioPlayer.shared.play(song: song)
            DispatchQueue.global().async {
                AudioPlayer.shared.queue(songs: Array(songs.dropFirst(index + 1)))
            }
        case is Album:
            guard let albums = self.contents as? [Album],
                let album = selectedContent as? Album else {
                    return
            }
            self.contents = album.songs
            self.parentContent = album
            self.parentContents = albums
        case is Playlist:
            guard let playlists = self.contents as? [Playlist],
                let playlist = selectedContent as? Playlist else {
                    return
            }
            self.contents = playlist.songs
            self.parentContent = playlist
            self.parentContents = playlists
        default:
            break
        }
    }
    
    func popToParent() {
        guard let parentContents = self.parentContents else { return }
        self.contents = parentContents
        self.parentContents = nil
        self.parentContent = nil
        // Polish: mechanism to scroll to original parent
    }
    
    func getContent<T: Content>(type: T.Type,
                                page: Int = 1,
                                append: Bool = false) {
        getContent(type: type, parentType: nil as Song.Type?, page: page, append: append)
    }
    
    
    func getContent<T: Content, U: Content>(type: T.Type,
                                            parentType: U.Type? = nil,
                                            page: Int = 1,
                                            append: Bool = false) {
        self.currentPage = page
        self.contentType = type
        self.isLoading = true
        ArchiveClient.shared.getContent(type: type, parentType: parentType, page: page, completionHandler: { fetchedContent in
            DispatchQueue.main.async {
                if append {
                    self.contents.append(contentsOf: fetchedContent)
                } else {
                    self.contents = fetchedContent
                }
                self.isLoading = false
            }
        })
    }
    
    func getMoreContent() {
        // dry https://stackoverflow.com/questions/45234233/why-cant-i-pass-a-protocol-type-to-a-generic-t-type-parameter
        self.currentPage += 1
        switch contentType {
        case is Song.Type:
            getContent(type: Song.self, page: self.currentPage, append: true)
        case is Album.Type:
            getContent(type: Album.self, page: self.currentPage, append: true)
        case is Artist.Type:
            getContent(type: Artist.self, page: self.currentPage, append: true)
        case is Playlist.Type:
            getContent(type: Playlist.self, page: self.currentPage, append: true)
        default:
            break
        }
    }

}
