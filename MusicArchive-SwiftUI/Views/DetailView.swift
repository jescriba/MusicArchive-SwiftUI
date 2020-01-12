//
//  DetailView.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 1/10/20.
//  Copyright © 2020 joshua. All rights reserved.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @State var sortCollapsed: Bool = true
    @State var sortType: SortType = .id
    var content: Content
    
    var body: some View {
        // Tried using ScrollView > VStack  instead to get collapsing nav bar but awkward scrolling
        VStack {
            Text(self.content.detailDescription()).padding(.bottom, 5)
            if self.content.hasChildren() {
                SortList(collapsed: $sortCollapsed, type: $sortType)
            }
            List(self.content.children().sorted(by: sortType), id: \.id) { child in
                ContentRow(content: child)
                    .onTapGesture {
                        guard let songs = self.content.children() as? [Song],
                            let song = child as? Song,
                            let index = songs.firstIndex(where: { $0 == song }) else {
                                return
                        }
                        AudioPlayer.shared.clearQueue()
                        AudioPlayer.shared.play(song: song)
                        DispatchQueue.global().async {
                            AudioPlayer.shared.queue(songs: Array(songs.dropFirst(index + 1)))
                        }
                }
            }
        }
        .navigationBarTitle(self.content.name)
        .navigationBarItems(trailing: self.content.hasChildren() ? AnyView(SortView(collapsed: $sortCollapsed)) : AnyView(EmptyView()))
    }
    
}
