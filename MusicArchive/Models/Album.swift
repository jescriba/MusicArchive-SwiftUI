// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import Tagged

struct Album: Codable, Equatable {
    typealias Id = Tagged<Album, Int>
    var id: Id
    var createdAt: Date
    var name: String
    var description: String?
    var songs: [Song]
    var artists: [Artist]
}

extension Album: Content {
    func children() -> [Song] {
        songs
    }

    func detailDescription() -> String {
        artists.names()
    }

    static var urlPath: String { "albums" }
    static var description: String { "Albums" }
    static func imageName() -> String { "rectangle.stack" }
    static var contentType: ContentType { .albums }
}
