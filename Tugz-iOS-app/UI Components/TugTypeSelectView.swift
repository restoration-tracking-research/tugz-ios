//
//  TugTypeSelectView.swift
//  Tugz-iOS-app
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
    
    var prefs: UserPrefs { config.prefs }
    
    @State var tug: Tug
    
    @State var isManual: Bool
    
    @State var manualMethod: ManualMethod? {
        didSet {
            if let manualMethod = manualMethod {
                tug.method = .manual(method: manualMethod)
            }
        }
    }
    @State var device: Device? {
        didSet {
            if let device = device {
                tug.method = .device(device: device)
            }
        }
    }
    
    var toggleTitle: String {
        isManual ? "Manual Method (tap to change)" : "Using a Device (tap to change)"
    }
    
    var tugEndInfoString: String {
        isManual ? "The app will record your manual session tug time." : "Your session will continue in the background until you come back and end it."
    }
    
    var body: some View {
        
        VStack {
        
            Toggle(toggleTitle, isOn: $isManual)
                .toggleStyle(CheckToggleStyle())
            
            if isManual {

                Text("Optional: Which method?")
                    .font(.footnote).italic()
                    .padding(.top, 20)
                
                Picker("", selection: $manualMethod) {
                    ForEach(ManualMethod.allCases) { method in
                        Text(method.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)

            } else {

                Text("Optional: Which device?")
                    .font(.footnote).italic()
                    .padding(.top, 20)

                Picker("", selection: $device) {
                    ForEach(prefs.userOwnedDevices, id: \.self) { device in
                        Text(device.displayName)
                    }
                }
                .pickerStyle(.inline)
                .padding(.horizontal, 20)
                .padding(.vertical, -40)
            }
            
            Text(tugEndInfoString)
                .font(.footnote).italic()
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct TugTypeSelectView_Previews: PreviewProvider {
    
    static let config = Config(forTest: true)
    
    static var previews: some View {
        TugTypeSelectView(config: config, tug: Tug.testTug(), isManual: true)
            .previewLayout(.sizeThatFits)
        
        TugTypeSelectView(config: config, tug: Tug.testTug(), isManual: false)
            .previewLayout(.sizeThatFits)
    }
}
