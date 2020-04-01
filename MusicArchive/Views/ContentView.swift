// Copyright (c) 2020 Joshua Escribano-Fontanet

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contentObserver: ContentObserver
    @State var hasLoaded = false
    @State var currentMaxIndex = 0

    var body: some View {
        NavigationView {
            // SwiftUI doesn't seem to play well with NavigationStack > VStack > List
            List(self.contentObserver.contents.enumerated().map { $0 }, id: \.element.id) { index, content in
                NavigationLink(destination: DetailView(content: content)) {
                    HStack {
                        ContentRow(content: content)
                        if content is Song {
                            Spacer()
                            Image(systemName: "play.fill").padding(.trailing, 20)
                                .onTapGesture {
                                    guard let songs = self.contentObserver.contents as? [Song],
                                        let song = content as? Song,
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
                }.onAppear(perform: {
                    if (index % self.contentObserver.pageSize) == 0,
                        index > 0,
                        index > self.currentMaxIndex {
                        self.currentMaxIndex = index // Prevent scrolling _up_ from incrementing current page
                        self.contentObserver.getMoreContent()
                    }
                })
            }.onAppear(perform: {
                if !self.hasLoaded {
                    self.contentObserver.getContent()
                }
                self.hasLoaded = true
            })
                .navigationBarTitle(self.contentObserver.type.rawValue.capitalized)
                .navigationBarItems(trailing: self.contentObserver.isLoading ? AnyView(LoadingView().padding(.trailing, 20)) : AnyView(EmptyView()))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentObserver(type: .artists))
    }
}
