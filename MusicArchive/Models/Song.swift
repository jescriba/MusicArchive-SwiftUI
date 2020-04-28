// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import Tagged

struct Song: Codable, Equatable {
    typealias Id = Tagged<Song, Int>

    var id: Id
    var createdAt: Date
    var name: String
    var description: String?
    var url: URL?
    var recordedAt: Date?
    var artists: [Artist]
}

extension Song: Content {
    func children() -> [Song] { [] }

    func detailDescription() -> String {
        let artistNames = artists.names()
        if let description = description {
            return "\(artistNames) \n \(description)"
        } else {
            return artistNames
        }
    }

    static var urlPath: String { "songs" }
    static var description: String { "Songs" }
    static func imageName() -> String { "music.note" }
    static var contentType: ContentType { .songs }
}

extension Array where Element == Artist {
    func names() -> String {
        reduce("by: ") { result, artist in
            "\(result) \(artist.name)"
        }
    }
}
