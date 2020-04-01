//
//  Artist.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

struct Artist: Codable, Equatable, Content {
    var id: Int
    var createdAt: Date
    var name: String
    var description: String?
}
