//
//  ArchiveClient.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

class ArchiveClient {
    static let shared = ArchiveClient()
    static let endpoint = "https://www.my-music-archive.com"
    
    private init() { }
    
    func getContent(type: ContentType,
                    page: Int = 1,
                    completionHandler: @escaping  (([Content]) -> ())) {
        guard let url = ArchiveClient.urlForContent(type: type, page: page) else { return }
        switch type {
        case .artists:
            getContent(type: Artist.self, url: url, page: page, completionHandler: completionHandler)
        case .albums:
            getContent(type: Album.self, url: url, page: page, completionHandler: completionHandler)
        case .playlists:
            getContent(type: Playlist.self, url: url, page: page, completionHandler: completionHandler)
        case .songs:
            getContent(type: Song.self, url: url, page: page, completionHandler: completionHandler)
        }
    }
    
    func getContent<T: Content>(type: T.Type, url: URL, page: Int = 1, completionHandler: @escaping  (([T]) -> ())) {
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request, completionHandler: { (dataO, response, errror) in
            guard let data = dataO else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601())
            guard let content = try? decoder.decode(Array<T>.self, from: data) else { return }
            completionHandler(content)
        }).resume()
    }
    
    static func urlForContent(type: ContentType, page: Int) -> URL? {
        return URL(string: "\(endpoint)/\(type.rawValue)?page=\(page)")
    }
}
