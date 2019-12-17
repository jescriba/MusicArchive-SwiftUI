//
//  ArchiveClient.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

protocol Content: Codable {
    var name: String { get }
    var description: String? { get }
}

extension Content {
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
}

class ArchiveClient {
    static let shared = ArchiveClient()
    let endpoint = "https://www.my-music-archive.com"
    
    private init() { }
    
    func getContent<T: Content>(type: T.Type, completionHandler: @escaping  (([T]) -> ())) {
        guard let url = urlForContent(type: type) else { return }
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
    
    private func urlForContent<T: Content>(type: T.Type) -> URL? {
        switch type {
        case is Song.Type:
            return URL(string: "\(endpoint)/songs")
        case is Artist.Type:
            return URL(string: "\(endpoint)/artists")
        case is Album.Type:
            return URL(string: "\(endpoint)/albums")
        case is Playlist.Type:
            return URL(string: "\(endpoint)/playlists")
        default:
            return nil
        }
    }
}
