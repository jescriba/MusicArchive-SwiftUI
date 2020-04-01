// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation

extension Array {
    /// Appends to array with max array count. If array exceeds max count the first item will be dropped.
    mutating func append(_ item: Element, max: Int) {
        let difference = count - max
        if difference > 0 {
            removeFirst(difference)
        }
        append(item)
    }
}

extension Array where Element == Artist {
    func names() -> String {
        reduce("by: ") { result, artist in
            "\(result) \(artist.name)"
        }
    }
}

extension Array where Element == Content {
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
