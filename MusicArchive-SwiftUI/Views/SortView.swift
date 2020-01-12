//
//  SortView.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 1/10/20.
//  Copyright © 2020 joshua. All rights reserved.
//

import Foundation
import SwiftUI

struct SortView: View {
    @Binding var collapsed: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.collapsed = !self.collapsed
                }
            }) {
                Text("Sort")
                Image(systemName: "chevron.right.circle")
                    .rotationEffect(.degrees(!collapsed ? 90 : 0))
            }.padding(.horizontal, 30)
        }
    }
}

struct SortList: View {
    @Binding var collapsed: Bool
    @Binding var type: SortType
    
    var body: some View {
        VStack {
            if !self.collapsed {
                ForEach(SortType.types(), id: \.self, content: { type in
                    HStack {
                        Text(type.rawValue)
                            .onTapGesture {
                                self.type = type
                        }
                        if type == self.type {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }).transition(.move(edge: .trailing))
            }
        }
    }
}
