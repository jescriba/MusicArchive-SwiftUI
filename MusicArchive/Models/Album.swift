// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation

struct Album: Codable, Content {
    var id: Int
    var createdAt: Date
    var name: String
    var description: String?
    var songs: [Song]
    var artists: [Artist]

    func children() -> [Content] {
        songs
    }

    func detailDescription() -> String {
        artists.names()
    }
}
