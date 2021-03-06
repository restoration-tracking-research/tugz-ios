//
//  ProgressCircle.swift
//  Tugz
//
//  Created by Charlie Williams on 04/10/2021.
//

import SwiftUI

struct ProgressCircle: View {
    
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(progress <= 1 ? .red : .green)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(progress <= 1 ? .red : .green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            Text(String(format: "%.0f%%", progress * 100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}

struct TugzProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .progressViewStyle(.circular)
            .shadow(color: Color(red: 1, green: 0, blue: 0.6),
                    radius: 4.0, x: 1.0, y: 2.0)
    }
}
