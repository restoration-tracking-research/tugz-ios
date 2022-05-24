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
        tug?.state == .due || tug?.state == .scheduled
    }
    
    var tugButtonTitle: String {
        
        guard let tug = tug else {
            return ""
        }
        
        if canStartTug {
            return "Tap to Start"
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
    
    @State private var showingActionSheet = false
    
    init(config: Config, tug: Tug?, isPresented: Binding<Bool>) {
        self.config = config
        self.tug = tug
        self.isPresented = isPresented
        percentDone = tug?.percentDone ?? 0
    }
    
    var backButton: some View {
        Button(action: {
            self.showingActionSheet.toggle()
        }, label: {
            Image(systemName: "xmark.circle.fill")
        })
    }
    
    var body: some View {
        
        ZStack {
            
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            Image(systemName: "t.circle.fill")
                .font(.system(size: 500, weight: .heavy))
                .frame(width: 150, height: 150)
                .foregroundColor(.accentColor)
                .position(x: 80, y: 120)
                .opacity(0.3)
            
            VStack {
                
                Spacer(minLength: 55)
                
                Text("Session in Progress")
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                
                Text(navSubtitleText)
                    .font(.subheadline)
                
                Button {
                    tug!.startTug()
                } label: {
                    Text(tugButtonTitle)
                        .frame(width: 250)
                }
                .buttonStyle(FilledButton())
                .disabled(!canStartTug)
                .padding(.vertical, 44)
                
                ProgressCircle(progress: percentDone)
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
                    Spacer()
                    
                    Button {
                        showingActionSheet.toggle()
                    } label: {
                        Text("Done!")
                            .frame(width: 250)
                    }
                    .buttonStyle(FilledButton())
                    .padding(.bottom, 75)
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
                }
                
                Spacer()
            }
            .onReceive(timer) { _ in
                self.percentDone = tug?.percentDone ?? 0
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if tug == nil {
                    tug = Tug(scheduledFor: nil, scheduledDuration: config.prefs.tugDuration.converted(to: .seconds).value)
                }
            }
        }
    }
}

struct TugView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
            TugView(config: Config(forTest: true), tug: Tug.testTugInProgress(), isPresented: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                .previewDisplayName("iPhone 12")
            
            TugView(config: Config(forTest: true), tug: Tug.testTugInProgress(), isPresented: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
                .previewDisplayName("iPhone 12 Pro Max")
//        }
    }
}
