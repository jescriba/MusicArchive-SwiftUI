//
//  Array+Extensions.swift
//  MusicArchive-SwiftUI
//
//  Created by Joshua Escribano on 12/19/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

extension Array {
    /// Appends to array with max array count. If array exceeds max count the first item will be dropped.
    mutating func append(_ item: Element, max: Int) {
        let difference = self.count - max
        if difference > 0 {
            self.removeFirst(difference)
        }
        self.append(item)
    }
}

extension Array where Element == Artist {
    
    func names() -> String {
        self.reduce("by: ", { result, artist in
            "\(result) \(artist.name)"
        })
    }
    
}

extension Array where Element == Content {
    
    mutating func sort(by sortType: SortType) {
        // dry - thought this would originally need to be more custom
        switch sortType {
        case .id:
            self.sort(by: { $0.id < $1.id })
        case .name:
            self.sort(by: { $0.name < $1.name })
        case .date:
            self.sort(by: { $0.createdAt < $1.createdAt })
        }
    }
    
    func sorted(by sortType: SortType) -> [Element] {
        var arr = self
        arr.sort(by: sortType)
        return arr
    }
    
}
