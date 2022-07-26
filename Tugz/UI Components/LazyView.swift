//
//  LazyView.swift
//  Tugz
//
//  Created by Charlie Williams on 02/06/2022.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
