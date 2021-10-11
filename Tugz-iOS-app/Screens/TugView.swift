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
    @State var isPresented: Binding<Bool>
    
    var canStartTug: Bool {
        state == .due || state == .scheduled
    }
    
    var tugButtonTitle: String {
        canStartTug ? "Ready to Tug" : "Tugging now…"
    }
    
    @State var percentDone: Double
    @State var state: Tug.State
    
    @State private var showingActionSheet = false
    
    init(tug: Tug, isPresented: Binding<Bool>) {
        self.tug = tug
        self.isPresented = isPresented
        percentDone = tug.percentDone
        state = tug.state
    }
    
    var body: some View {
        
        VStack {
            Text("Tug Session")
                .font(.system(.largeTitle))
                .padding(.top, 50)
            HStack {
                Text("Scheduled for")
                Text(formatter.string(from: tug.scheduledFor))
            }
            
            Button(tugButtonTitle) {
                self.tug.startTug()
            }
            .buttonStyle(FilledButton())
            .disabled(!canStartTug)
            
            ProgressCircle(progress: $percentDone)
                .frame(width: 150.0, height: 150.0)
                .padding(22)
            
            if let start = tug.start {
                HStack {
                    Text("Started at")
                    Text(formatter.string(from: start))
                    Text("until")
                    Text(formatter.string(from: start.advanced(by: tug.scheduledDuration)))
                }
            }
            Spacer()
            
            Button("Done!") {
                self.showingActionSheet.toggle()
            }
            .buttonStyle(FilledButton())
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("All Done?"), message: nil, buttons: [
                    .default(Text("Finish Tugging")) {
                        self.tug.endTug()
                        self.isPresented.wrappedValue = false
                    },
                    .cancel(Text("Keep Tugging"))
                ])
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button(action: {
            self.showingActionSheet.toggle()
        }, label: {
            Image(systemName: "xmark.circle.fill")
        })
    }
}

struct TugView_Previews: PreviewProvider {
    static var previews: some View {
        TugView(tug: Tug.testTugInProgress(), isPresented: .constant(true))
    }
}
