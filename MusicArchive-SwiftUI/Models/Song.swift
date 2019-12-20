//
//  Song.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

struct Song: Codable, Equatable, Content {
    var name: String
    var description: String?
    var url: String?
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    static func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.name == rhs.name &&
            lhs.url == rhs.url
    }
}
