// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import Tagged

struct Artist: Codable, Equatable {
    typealias Id = Tagged<Artist, Int>

    var id: Id
    var createdAt: Date
    var name: String
    var description: String?
}

extension Artist: Content {
    static var urlPath: String { "artists" }
    static var description: String { "Artists" }
    static func imageName() -> String { "person.3" }
    static var contentType: ContentType { .artists }

    func children() -> [Song] {
        []
    }
}
