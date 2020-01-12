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
    var createdAt: Date
    var name: String
    var description: String?
    var url: String?
    var recordedAt: Date?
    var artists: [Artist]?
    
    func detailDescription() -> String {
        guard let artistNames = artists?.names() else { return " " }
        
        if let description = description {
            return "\(artistNames) \n \(description)"
        } else {
            return artistNames
        }
    }
}
