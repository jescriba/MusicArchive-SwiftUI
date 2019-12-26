//
//  LoadingView.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/25/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation
import SwiftUI

struct OffsetEffect: GeometryEffect {
    var percent: CGFloat = 0
    var offset: CGFloat = 5

    var animatableData: CGFloat {
      get { return percent }
      set { percent = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
      let angle = 2 * .pi * percent
      let pt = CGPoint(x: cos(angle) * offset, y: 0)
        return ProjectionTransform(CGAffineTransform(translationX: pt.x
            , y: 0))
    }
}

struct LoadingView: View {
    @State var percent: CGFloat = 0
    
    var animation: Animation {
        Animation.linear(duration: 0.7).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path(ellipseIn: CGRect(x: geometry.size.width / 2 - 15, y: 0, width: 15, height: 15))
                .fill(Color("loadingColor"))
                .modifier(OffsetEffect(percent: self.percent, offset: -10))
            Path(ellipseIn: CGRect(x: geometry.size.width / 2 + 5, y: 0, width: 15, height: 15))
                .fill(Color("loadingColor"))
                .modifier(OffsetEffect(percent: self.percent, offset: 10))
                .onAppear() {
                    withAnimation(self.animation) {
                        self.percent = 1.0
                    }
            }
        }
    }
}
