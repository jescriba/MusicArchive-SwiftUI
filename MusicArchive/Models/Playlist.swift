// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation

struct Playlist: Codable, Content {
    var id: Int
    var createdAt: Date
    var name: String
    var description: String?
    var songs: [Song]

    func children() -> [Content] {
        songs
    }
}
