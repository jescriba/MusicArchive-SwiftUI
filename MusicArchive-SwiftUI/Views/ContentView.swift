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
    @EnvironmentObject var authorizer: Authorizer
    @State var showSort = false
    @State var sortType: SortType? = nil {
        didSet {
            let _ = contentObserver.parentContent
            guard let _ = sortType else { return }
            // polish - sorting for large content lags up
            DispatchQueue.global(qos: .userInitiated).async {
                let sorted = self.contentObserver.contents.sorted(by: self.sortType!)
                DispatchQueue.main.async {
                    self.contentObserver.contents = sorted
                }
            }
        }
    }
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
                LoadingView().frame(width: 100, height: 20, alignment: .top)
            }
            Spacer()
            if contentObserver.parentContent?.name != nil {
                HStack {
                    Text(contentObserver.parentContent!.name)
                    .underline()
                        .padding(.horizontal, 30)
                    Spacer()
                    VStack {
                        Button(action: {
                            withAnimation {
                                self.showSort = !self.showSort
                            }
                        }) {
                            Text("Sort")
                            Image(systemName: "chevron.right.circle")
                                .rotationEffect(.degrees(showSort ? 90 : 0))
                        }.padding(.horizontal, 30)
                        
                        // refactor
                        if self.showSort {
                            ForEach(SortType.types(), id: \.self, content: { type in
                                HStack {
                                    Text(type.rawValue)
                                        .onTapGesture {
                                            self.sortType = type
                                    }
                                    if type == self.sortType {
                                        Image(systemName: "checkmark.circle")
                                    }
                                }
                            }).transition(.move(edge: .trailing))
                        }
                    }
                }
            }
            Spacer()
            List(self.contentObserver.contents.enumerated().map({ $0 }), id: \.element.id) { index, content in
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
        }.overlay(!self.authorizer.authorized ? AuthView().environmentObject(authorizer).background(Color(UIColor.systemBackground)) : nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentObserver())
    }
}
