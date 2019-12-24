//
//  Song.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

struct Song: Codable, Equatable, Content {
    var id: Int
    var name: String
    var description: String?
    var url: String?
}
