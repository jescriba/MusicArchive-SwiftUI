// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation

struct Artist: Codable, Equatable, Content {
    var id: Int
    var createdAt: Date
    var name: String
    var description: String?
}
