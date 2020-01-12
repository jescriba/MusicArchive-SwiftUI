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
    case artists
    case songs
    case albums
    case playlists
    
    func imageName() -> String {
        switch self {
        case .artists:
            return "person.3"
        case .songs:
            return "music.note"
        case .albums:
            return "rectangle.stack"
        case .playlists:
            return "music.note.list"
        }
    }
    
    func type() -> Content.Type {
        switch self {
        case .artists:
            return Artist.self
        case .songs:
            return Song.self
        case .albums:
            return Album.self
        case .playlists:
            return Playlist.self
        }
    }
}

protocol Content: Codable {
    var id: Int { get }
    var createdAt: Date { get }
    var name: String { get }
    var description: String? { get }
    func children() -> [Content]
    func detailDescription() -> String
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
    
    // default to empty children
    func children() -> [Content] {
        return [Song]()
    }
    
    func hasChildren() -> Bool {
        return children().count > 0
    }
    
    func detailDescription() -> String {
        return " "
    }

}
