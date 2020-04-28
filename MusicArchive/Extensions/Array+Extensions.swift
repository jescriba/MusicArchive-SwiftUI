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
