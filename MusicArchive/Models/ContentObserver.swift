// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation

final class ContentObserver<Content: MusicArchiveFramework.Content>: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var contents = [Content]()
    var currentPage: Int = 1
    let pageSize: Int = 20

    func getContent(page: Int = 1, append: Bool = false) {
        currentPage = page
        isLoading = true
        Client<Content>(page: page).fetch { [weak self] result in
            guard let self = self, case let .success(content) = result else { return }
            if append {
                self.contents.append(contentsOf: content)
            } else {
                self.contents = content
            }
            self.isLoading = false
        }
    }

    func getMoreContent() {
        currentPage += 1
        getContent(page: currentPage, append: true)
    }
}
