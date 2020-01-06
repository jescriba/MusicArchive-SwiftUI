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
    let type: ContentType
    var currentPage: Int = 1
    let pageSize: Int = 20
    
    init(type: ContentType) {
        self.type = type
    }
    
    @Published var contents = [Content]()
    @Published var parentContent: Content?
    var parentContents: [Content]?
    lazy var selectionAction: (_: Content) -> Void = { selectedContent in
//        switch self.contents.first {
//        case is Artist:
//            guard let artists = self.contents as? [Artist],
//                let artist = selectedContent as? Artist else {
//                    return
//            }
//            self.contents = [Song]()
//            self.getContent(type: Song.self, parentType: Artist.self)
//            self.parentContent = artist
//            self.parentContents = artists
//        case is Song:
//            guard let songs = self.contents as? [Song],
//                let song = selectedContent as? Song,
//                let index = songs.firstIndex(where: { $0 == song }) else {
//                    return
//            }
//            AudioPlayer.shared.clearQueue()
//            AudioPlayer.shared.play(song: song)
//            DispatchQueue.global().async {
//                AudioPlayer.shared.queue(songs: Array(songs.dropFirst(index + 1)))
//            }
//        case is Album:
//            guard let albums = self.contents as? [Album],
//                let album = selectedContent as? Album else {
//                    return
//            }
//            self.contents = album.songs
//            self.parentContent = album
//            self.parentContents = albums
//        case is Playlist:
//            guard let playlists = self.contents as? [Playlist],
//                let playlist = selectedContent as? Playlist else {
//                    return
//            }
//            self.contents = playlist.songs
//            self.parentContent = playlist
//            self.parentContents = playlists
//        default:
//            break
//        }
    }
    
    func popToParent() {
        guard let parentContents = self.parentContents else { return }
        self.contents = parentContents
        self.parentContents = nil
        self.parentContent = nil
        // Polish: mechanism to scroll to original parent
    }

    func getContent(page: Int = 1,
                    append: Bool = false) {
        self.currentPage = page
        self.isLoading = true
        ArchiveClient.shared.getContent(type: type, page: page, completionHandler: { fetchedContent in
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
        self.currentPage += 1
        getContent(page: self.currentPage, append: true)
    }

}
