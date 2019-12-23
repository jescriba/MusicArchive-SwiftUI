//
//  ContentView.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/8/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var loading: Bool = false
    @State var contentType: Content.Type = Artist.self
    @EnvironmentObject var content: ContentObserver
    @EnvironmentObject var audioPlayer: AudioPlayer
    @State var currentPage: Int = 1
    @State var currentMaxIndex = 0
    let pageSize: Int = 20

    init() {
         UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        VStack {
            if content.content.first?.typeString() != nil {
                Text(content.content.first!.typeString())
                    .fontWeight(.heavy)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            if loading {
                Text("Loading...")
            }
            Spacer()
            //List(self.content.content.indices, id: \.self) { index in
            List(self.content.content.enumerated().map({ $0 }), id: \.element.name) { index, content in
                ContentRow(content: content)
                    .onTapGesture {
                        self.content.selectionAction(content)
                }.onAppear(perform: {
                    if (index % self.pageSize) == 0 &&
                        index > 0 &&
                        index > self.currentMaxIndex {
                        self.currentMaxIndex = index // Prevent scrolling _up_ from incrementing current page
                        DispatchQueue.global(qos: .background).async {
                            self.currentPage += 1
                            self.getMoreContent()
                        }
                    }
                })
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.getContent(type: Album.self)
                }) {
                    Text("Albums")
                        .fontWeight(contentType == Album.self ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Artist.self)
                }) {
                    Text("Artists")
                        .fontWeight(contentType == Artist.self ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Song.self)
                }) {
                    Text("Songs")
                        .fontWeight(contentType == Song.self ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.getContent(type: Playlist.self)
                }) {
                    Text("Playlists")
                        .fontWeight(contentType == Playlist.self ? .heavy : .semibold)
                }
                Spacer()
            }
            Spacer()
            AudioBar().environmentObject(audioPlayer)
        }
    }
    
    func getContent<T: Content>(type: T.Type) {
        self.contentType = type
        self.currentMaxIndex = 0
        self.currentPage = 0
        self.loading = true
        ArchiveClient.shared.getContent(type: type, completionHandler: { fetchedContent in
            DispatchQueue.main.async {
                self.content.content = fetchedContent
                self.loading = false
            }
        })
    }
    func getMoreContent<T: Content>(type: T.Type, page: Int) {
        self.loading = true
        ArchiveClient.shared.getContent(type: type, page: page, completionHandler: { fetchedContent in
            DispatchQueue.main.async {
                self.content.content.append(contentsOf: fetchedContent)
                self.loading = false
            }
        })
    }
    func getMoreContent() {
        // dry https://stackoverflow.com/questions/45234233/why-cant-i-pass-a-protocol-type-to-a-generic-t-type-parameter
        switch contentType {
        case is Song.Type:
            getMoreContent(type: Song.self, page: self.currentPage)
        case is Album.Type:
            getMoreContent(type: Album.self, page: self.currentPage)
        case is Artist.Type:
            getMoreContent(type: Artist.self, page: self.currentPage)
        case is Playlist.Type:
            getMoreContent(type: Playlist.self, page: self.currentPage)
        default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentObserver())
    }
}
