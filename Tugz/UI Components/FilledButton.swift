//
//  FilledButton.swift
//  Tugz
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct FilledButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .frame(minWidth: 120, minHeight: 38)
            .padding()
            .background(isEnabled ? Color.accentColor : .gray)
            .cornerRadius(8)
    }
}

