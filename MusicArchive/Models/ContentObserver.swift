//
//  ContentObserver.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/15/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

class ContentObserver: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var contents = [Content]()
    let type: ContentType
    var currentPage: Int = 1
    let pageSize: Int = 20
    
    init(type: ContentType) {
        self.type = type
    }
    
    func getContent(page: Int = 1,
                    append: Bool = false) {
        self.currentPage = page
        self.isLoading = true
        ArchiveClient.shared.getContent(type: type, page: page, completionHandler: { fetchedContent in
            DispatchQueue.main.async {
                if append {
                    self.contents.append(contentsOf: fetchedContent)
                } else {
                    self.contents = fetchedContent
                }
                self.isLoading = false
            }
        })
    }
    
    func getMoreContent() {
        self.currentPage += 1
        getContent(page: self.currentPage, append: true)
    }

}
