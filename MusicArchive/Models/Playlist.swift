// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import Tagged

struct Playlist: Codable, Equatable {
    typealias Id = Tagged<Playlist, Int>

    var id: Id
    var createdAt: Date
    var name: String
    var description: String?
    var songs: [Song]
}

extension Playlist: Content {
    static var urlPath: String { "playlists" }
    static var description: String { "Playlist" }
    static func imageName() -> String { "music.note.list" }
    static var contentType: ContentType { .playlists }

    func children() -> [Song] {
        songs
    }
}
