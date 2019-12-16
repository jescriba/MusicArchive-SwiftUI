//
//  ContentObserver.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/15/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

class ContentObserver: ObservableObject {
    @Published var content = [Content]()
}
