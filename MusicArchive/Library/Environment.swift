// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation

final class Environment: ObservableObject {
    var store = AppState()
}

var Current = Environment()
