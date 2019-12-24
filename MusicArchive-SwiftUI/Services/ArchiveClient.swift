//
//  ArchiveClient.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

enum ContentType: String {
    case artist
    case song
    case album
    case playlist
}

protocol Content: Codable {
    var id: Int { get }
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

class ArchiveClient {
    static let shared = ArchiveClient()
    static let endpoint = "https://www.my-music-archive.com"
    
    private init() { }
    
    func getContent<T: Content>(type: T.Type,
                                page: Int = 1,
                                completionHandler: @escaping  (([T]) -> ())) {
        getContent(type: type, parentType: nil as Song.Type?, page: page, completionHandler: completionHandler)
    }
    
    func getContent<T: Content, U: Content>(type: T.Type,
                                            parentType: U.Type? = nil,
                                            page: Int = 1,
                                            completionHandler: @escaping  (([T]) -> ())) {
        guard let url = ArchiveClient.urlForContent(type: type, parentType: parentType, page: page) else { return }
        getContent(url: url, completionHandler: completionHandler)
    }
    
    func getContent<T: Content>(url: URL, page: Int = 1, completionHandler: @escaping  (([T]) -> ())) {
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request, completionHandler: { (dataO, response, errror) in
            guard let data = dataO else { return }
            let decoder = JSONDecoder()
            guard let content = try? decoder.decode(Array<T>.self, from: data) else { return }
            completionHandler(content)
            }).resume()
    }
    
    static func urlForContent<T: Content, U: Content>(type: T.Type, parentType: U.Type? = nil, page: Int) -> URL? {
        switch type {
        case is Song.Type:
            return URL(string: "\(endpoint)/songs?page=\(page)")
        case is Artist.Type:
            return URL(string: "\(endpoint)/artists?page=\(page)")
        case is Album.Type:
            return URL(string: "\(endpoint)/albums?page=\(page)")
        case is Playlist.Type:
            return URL(string: "\(endpoint)/playlists?page=\(page)")
        default:
            return nil
        }
    }
}
