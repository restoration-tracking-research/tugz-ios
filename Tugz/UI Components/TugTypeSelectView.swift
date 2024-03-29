//
//  TugTypeSelectView.swift
//  Tugz
//
//  Created by Charlie Williams on 25/05/2022.
//

import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        Button {
            configuration.isOn.toggle()
        } label: {
            
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "hands.clap" : "testtube.2")
                    .foregroundColor(.accentColor)
                    .accessibility(label: Text(configuration.isOn ? "Manual Methods" : "Using a Device"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct TugTypeSelectView: View {
    
    @ObservedObject var config: Config
    
    private var prefs: UserPrefs { config.prefs }
    
    @State var tug: Tug {
        didSet {
            if case .manual(method: let method) = tug.method {
                manualMethod = method
            } else if case .device(device: let device) = tug.method {
                self.device = device
            }
        }
    }
    
    @State var isManual: Bool
    
    @State var manualMethod: ManualMethod = .other
    @State var device: Device = .DTR
    
    var manualTitle: String {
        "Manual Method"
    }
    
    var deviceTitle: String {
        "Device Session"
    }
    
    var toggleTitle: String {
        isManual ? manualTitle : deviceTitle //"Manual Method (tap to change)" : "Using a Device (tap to change)"
    }
    
    var otherTypeTitle: String {
        isManual ? "Device" : "Manual"
    }
    
    var tugEndInfoString: String {
        isManual ? "The app will record your manual session tug time." : "Your session will continue in the background until you come back and end it."
    }
    
    var displayDevices: [Device] {
        prefs.userOwnedDevices.isEmpty ? Device.allCases : prefs.userOwnedDevices
    }
    
    init(config: Config, tug: Tug) {
        
        self.config = config
        self.tug = tug
        
        /// Default to whatever we used last
        if case .device = config.history.lastTug?.method {
            self.isManual = false
        } else {
            self.isManual = true
        }
        
        if let lastManual = config.history.lastManualMethod {
            self.manualMethod = lastManual
            tug.method = .manual(method: lastManual)
        }
        
        else if let lastDevice = config.history.lastDevice {
            self.device = lastDevice
            tug.method = .device(device: lastDevice)
        } else if let device = config.prefs.userOwnedDevices.first {
            self.device = device
            tug.method = .device(device: device)
        }
    }
    
    var body: some View {
        
        VStack {
        
            HStack {
                Image(systemName: isManual ? "hands.clap" : "testtube.2")
                Text(toggleTitle)
                Button("Switch to \(otherTypeTitle)") {
                    isManual.toggle()
                }
                .buttonStyle(.bordered)
            }
            
            if isManual {

                Text("Optional: Which method?")
                    .font(.footnote).italic()
                    .padding(.top, 20)
                
                Picker("", selection: $manualMethod) {
                    ForEach(ManualMethod.allCases, id: \.self) { method in
                        Text(method.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .id(manualMethod)
                .onChange(of: manualMethod) { newValue in
                    tug.method = .manual(method: newValue)
                }

            } else {

                Text("Optional: Which device?")
                    .font(.footnote).italic()
                    .padding(.top, 20)

                Picker("", selection: $device) {
                    ForEach(displayDevices, id: \.self) { device in
                        Text(device.displayName)
                    }
                }
                .pickerStyle(.inline)
                .padding(.horizontal, 20)
                .padding(.vertical, -40)
                .onChange(of: device) { newValue in
                    tug.method = .device(device: newValue)
                }
            }
            
            Text(tugEndInfoString)
                .font(.footnote).italic()
                .multilineTextAlignment(.center)
                .padding()
        }
        .animation(.default)
    }
}

struct TugTypeSelectView_Previews: PreviewProvider {
    
    static let config = Config(forTest: true)
    
    static var previews: some View {
        TugTypeSelectView(config: config, tug: Tug.testTug(manual: true))
            .previewLayout(.sizeThatFits)
        
        TugTypeSelectView(config: config, tug: Tug.testTug(manual: false))
            .previewLayout(.sizeThatFits)
    }
}
