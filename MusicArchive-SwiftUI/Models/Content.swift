//
//  Content.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/26/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

enum SortType: String {
    case id
    case name
    case date
    
    static func types() -> [SortType] {
        return [.id, .name, .date]
    }
}

enum ContentType: String {
    case artist
    case song
    case album
    case playlist
}

protocol Content: Codable {
    var id: Int { get }
    var createdAt: Date { get }
    var name: String { get }
    var description: String? { get }
}

extension Content {
    static func typeString() -> String {
        switch self {
        case is Artist.Type:
            return "Artists"
        case is Song.Type:
            return "Songs"
        case is Playlist.Type:
            return "Playlists"
        case is Album.Type:
            return "Albums"
        default:
            return ""
        }
    }
    
    func typeString() -> String {
        switch self {
        case is Artist:
            return "Artists"
        case is Song:
            return "Songs"
        case is Playlist:
            return "Playlists"
        case is Album:
            return "Albums"
        default:
            return ""
        }
    }
    
    static func ==(lhs: Content, rhs: Content) -> Bool {
        return lhs.id == rhs.id
    }

}
