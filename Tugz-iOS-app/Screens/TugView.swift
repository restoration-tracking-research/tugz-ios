//
//  TugView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 09/10/2021.
//

import SwiftUI

struct TugView: View {
    
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }()
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var tug: Tug
    
    @State var percentDone: Double
    @State var state: Tug.State
    
    init(tug: Tug) {
        self.tug = tug
        percentDone = tug.percentDone
        state = tug.state
    }
    
    var body: some View {
        
        VStack {
            Text("Tug Session")
                .font(.system(.largeTitle))
            HStack {
                Text("Scheduled for")
                Text(formatter.string(from: tug.scheduledFor))
            }
            Button("Ready to Tug") {
                self.tug.startTug()
            }
            .buttonStyle(FilledButton())
            
            ProgressCircle(progress: $percentDone)
                .frame(width: 150.0, height: 150.0)
                .padding(22)
            
//            VStack {
//                HStack {
//                    Text("Next session in")
//                    if #available(iOS 15.0, *) {
//                        Text(formattedTimeUntilNextTug)
//                            .monospacedDigit()
//                            .bold()
//                    } else {
//                        Text(formattedTimeUntilNextTug)
//                            .font(.system(size: 14, design: .monospaced))
//                            .bold()
//                    }
//                    Text("at")
//                    Text(formattedTimeOfNextTug)
//                        .bold()
//                }
//                Button("TUG NOW") {
//                    /// Transition to tug screen
//                }
//                .buttonStyle(FilledButton())
//            }
            Spacer()
            
//        }.progressViewStyle(TugzProgressViewStyle())
        }
    }
}

struct TugView_Previews: PreviewProvider {
    static var previews: some View {
        TugView(tug: Tug.testTug())
    }
}
