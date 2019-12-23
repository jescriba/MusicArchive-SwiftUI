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
    @EnvironmentObject var contentObserver: ContentObserver
    @EnvironmentObject var audioPlayer: AudioPlayer
    @State var currentMaxIndex = 0

    init() {
         UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        VStack {
            if contentObserver.contents.first?.typeString() != nil {
                Text(contentObserver.contents.first!.typeString())
                    .fontWeight(.heavy)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            if contentObserver.isLoading {
                Text("Loading...")
            }
            Spacer()
            if contentObserver.parentContent?.name != nil {
                Text(contentObserver.parentContent!.name)
            }
            Spacer()
            List(self.contentObserver.contents.enumerated().map({ $0 }), id: \.element.name) { index, content in
                ContentRow(content: content)
                    .onTapGesture {
                        self.contentObserver.selectionAction(content)
                }.onAppear(perform: {
                    guard self.contentObserver.parentContent == nil else { return }
                    
                    if (index % self.contentObserver.pageSize) == 0 &&
                        index > 0 &&
                        index > self.currentMaxIndex {
                        self.currentMaxIndex = index // Prevent scrolling _up_ from incrementing current page
                        self.contentObserver.getMoreContent()
                    }
                })
            }.gesture(DragGesture()
                .onEnded({ gesture in
                    if gesture.startLocation.x < CGFloat(100.0) && gesture.location.x > 60 {
                        self.contentObserver.popToParent()
                    }
                 }
            ))
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.contentObserver.getContent(type: Album.self)
                    self.currentMaxIndex = 0
                }) {
                    Text("Albums")
                        .fontWeight(self.contentObserver.contentType == Album.self ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.contentObserver.getContent(type: Artist.self)
                    self.contentObserver.parentContent = nil
                    self.currentMaxIndex = 0
                }) {
                    Text("Artists")
                        .fontWeight(self.contentObserver.contentType == Artist.self ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.contentObserver.getContent(type: Song.self)
                    self.contentObserver.parentContent = nil
                    self.currentMaxIndex = 0
                }) {
                    Text("Songs")
                        .fontWeight(self.contentObserver.contentType == Song.self ? .heavy : .semibold)
                }
                Spacer()
                Button(action: {
                    self.contentObserver.getContent(type: Playlist.self)
                    self.contentObserver.parentContent = nil
                    self.currentMaxIndex = 0
                }) {
                    Text("Playlists")
                        .fontWeight(self.contentObserver.contentType == Playlist.self ? .heavy : .semibold)
                }
                Spacer()
            }
            Spacer()
            AudioBar().environmentObject(audioPlayer)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentObserver())
    }
}
