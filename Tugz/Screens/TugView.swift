//
//  TugView.swift
//  Tugz
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
    
    @ObservedObject var tug: Tug
    @State var isPresented: Binding<Bool>
    
    var canStartTug: Bool {
        tug.state == .due || tug.state == .scheduled
    }
    
    var headerTitle: String {
        canStartTug ? "Ready to Tug?" : "Session in Progress"
    }
    
    var tugButtonTitle: String {
        
        if canStartTug {
            return "TAP TO START"
        } else {
            return "Tugging for \(tug.duration.minuteSecond)"
        }
    }
    
    var navSubtitleText: String {
        if let scheduledFor = tug.scheduledFor {
            return "Scheduled for \(formatter.string(from: scheduledFor))"
        } else {
            return ""
        }
    }
    
    @State var percentDone: Double
    
    @State private var showingActionSheet = false
    
    init(config: Config, tug: Tug? = nil, isPresented: Binding<Bool>) {
        self.config = config
        
        if let tug = tug, tug.state != .finished {
            self.tug = tug
            percentDone = tug.percentDone
        } else {
            let tug = config.scheduler.activeTug()
            self.tug = tug
            percentDone = tug.percentDone
        }
        
        self.isPresented = isPresented
    }
    
    var backButton: some View {
        Button(action: {
            self.showingActionSheet.toggle()
        }, label: {
            Image(systemName: "xmark.circle.fill")
        })
    }
    
    @State var scaled = false
    
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
                
                Text(headerTitle)
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                
                Text(navSubtitleText)
                    .font(.subheadline)
                    .padding(.bottom, 44)
                
                if canStartTug {
                    
                    /// Manual vs Device
                    TugTypeSelectView(config: config, tug: tug)
                    
                } else if case .manual(_) = tug.method {
                
                    ProgressCircle(progress: percentDone)
                        .frame(width: 150.0, height: 150.0)
                        .padding(22)
                    
                }
                
                Button {
                    tug.startTug()
                } label: {
                    Text(tugButtonTitle)
                        .bold()
                        .frame(width: 300, height: 55)
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(canStartTug ? .white : .black)
                .disabled(!canStartTug)
                .background(.clear)
                .cornerRadius(8)
                .padding(.bottom, 44)
//                .scaleEffect(x: scaled && !canStartTug ? 1.1 : 1)
//                .onAppear {
//                    withAnimation(.easeInOut(duration: 1)) {
//                        scaled.toggle()
//                    }
//                }
                
                if let start = tug.start {
                    VStack {
                        HStack {
                            Text("Started at")
                            Text(formatter.string(from: start))
                        }
                        if case .manual(_) = tug.method {
                            HStack {
                                Text("Tugging until")
                                Text(formatter.string(from: start.advanced(by: tug.scheduledDuration)))
                            }
                        } else {
                            Text("Feel free to background the app; your session will continue until you stop it.")
                                .padding()
                        }
                    }
                    Spacer()
                    
                    Button {
                        showingActionSheet.toggle()
                    } label: {
                        Text(tug.duration < 15 ? "Cancel" : tug.percentDone <= 1 ? "Stop" : "All Done")
                            .bold()
                            .frame(width: 300, height: 55)
                            .background(.clear)
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .background(tug.percentDone <= 1 ? Color.accentColor : .green)
                    .cornerRadius(8)
                    .padding(.bottom, 75)
                    .padding(.top, 22)
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("All Done?"), message: nil, buttons: [
                            .default(Text("Finish Tugging")) {
                                
                                tug.endTug()
                                config.history.append(tug)
                                
                                self.isPresented.wrappedValue = false
                                self.timer.upstream.connect().cancel()
                            },
                            .cancel(Text("Keep Tugging"))
                        ])
                    }
                }
                
                Spacer()
            }
            .onReceive(timer) { _ in
                self.percentDone = tug.percentDone
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct TugView_Previews: PreviewProvider {
    static var previews: some View {

            TugView(config: Config(forTest: true), tug: Tug.testTug(), isPresented: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
                .previewDisplayName("iPhone 12")
            
            TugView(config: Config(forTest: true), tug: Tug.testTugInProgress(), isPresented: .constant(true))
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
                .previewDisplayName("iPhone 12 Pro Max")
        
        
        TugView(config: Config(forTest: true), tug: Tug.testDeviceTug(), isPresented: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
    }
}
