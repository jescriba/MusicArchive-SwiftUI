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
