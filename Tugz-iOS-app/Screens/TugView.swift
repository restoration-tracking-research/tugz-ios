//
//  TugView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 09/10/2021.
//

import SwiftUI

struct TugView: View {
    
    let config: Config
    
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }()
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    @State var tug: Tug?
    @State var isPresented: Binding<Bool>
    
    var canStartTug: Bool {
        state == .due || state == .scheduled
    }
    
    var tugButtonTitle: String {
        
        guard let tug = tug else {
            return ""
        }
        
        if canStartTug {
            return "Ready to Tug"
        } else if tug.duration < 60 {
            return "Tugging for \(tug.duration.second) sec"
        } else {
            return "Tugging for \(tug.duration.minute):\(tug.duration.second)"
        }
    }
    
    var navSubtitleText: String {
        if let scheduledFor = tug?.scheduledFor {
            return "Scheduled for \(formatter.string(from: scheduledFor))"
        } else {
            return "Scheduled manually"
        }
    }
    
    @State var percentDone: Double
    @State var state: Tug.State?
    
    @State private var showingActionSheet = false
    
    init(config: Config, tug: Tug?, isPresented: Binding<Bool>) {
        self.config = config
        self.tug = tug
        self.isPresented = isPresented
        percentDone = tug?.percentDone ?? 0
        state = tug?.state
    }
    
    var backButton: some View {
        Button(action: {
            self.showingActionSheet.toggle()
        }, label: {
            Image(systemName: "xmark.circle.fill")
        })
    }
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading) {
                Text(navSubtitleText)
                    .font(.subheadline)
            }
            .padding()
            
            Button(tugButtonTitle) {
                tug!.startTug()
            }
            .buttonStyle(FilledButton())
            .disabled(!canStartTug)
            
            ProgressCircle(progress: $percentDone)
                .frame(width: 150.0, height: 150.0)
                .padding(22)
            
            if let tug = tug, let start = tug.start {
                VStack {
                    HStack {
                        Text("Started at")
                        Text(formatter.string(from: start))
                    }
                    HStack {
                        Text("Tugging until")
                        Text(formatter.string(from: start.advanced(by: tug.scheduledDuration)))
                    }
                }
            }
            Spacer()
            
            Button("Done!") {
                self.showingActionSheet.toggle()
            }
            .buttonStyle(FilledButton())
            .padding()
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("All Done?"), message: nil, buttons: [
                    .default(Text("Finish Tugging")) {
                        
                        self.tug!.endTug()
                        config.history.tugs.append(self.tug!)
                        config.history.save()
                        
                        self.isPresented.wrappedValue = false
                        
                        self.tug = nil
                        
                        self.timer.upstream.connect().cancel()
                    },
                    .cancel(Text("Keep Tugging"))
                ])
            }
            
            Spacer()
        }
        .onReceive(timer) { _ in
            self.percentDone = tug?.percentDone ?? 0
        }
        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: backButton)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Session in Progress")
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .padding()
            }
        }
        .onAppear {
            if tug == nil {
                tug = Tug(scheduledFor: nil, scheduledDuration: config.prefs.tugDuration.converted(to: .seconds).value)
            }
        }
    }
}

struct TugView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TugView(config: Config(forTest: true), tug: Tug.testTugInProgress(), isPresented: .constant(true))
        }
    }
}
