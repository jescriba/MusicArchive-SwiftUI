// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation

enum SortType: String {
    case id
    case name
    case date

    static func types() -> [SortType] {
        [.id, .name, .date]
    }
}

enum ContentType: Equatable {
    case artists
    case songs
    case albums
    case playlists
}

protocol Content: Codable, Equatable, Identifiable {
    associatedtype Id: RawRepresentable, Comparable, Hashable where Id.RawValue == Int
    var id: Id { get }
    var createdAt: Date { get }
    var name: String { get }
    var description: String? { get }

    associatedtype ChildContent: Content
    func children() -> [ChildContent]
    func detailDescription() -> String

    static var urlPath: String { get }
    static var description: String { get }
    static func imageName() -> String
    static var contentType: ContentType { get }
}

extension Content {
    func hasChildren() -> Bool {
        !children().isEmpty
    }

    func detailDescription() -> String {
        " "
    }
}

extension Array where Element: Content {
    mutating func sort(by sortType: SortType) {
        // dry - thought this would originally need to be more custom
        switch sortType {
        case .id:
            sort(by: { $0.id < $1.id })
        case .name:
            sort(by: { $0.name < $1.name })
        case .date:
            sort(by: { $0.createdAt < $1.createdAt })
        }
    }

    func sorted(by sortType: SortType) -> [Element] {
        var arr = self
        arr.sort(by: sortType)
        return arr
    }
}
