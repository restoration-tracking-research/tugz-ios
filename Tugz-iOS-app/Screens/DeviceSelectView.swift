//
//  DeviceSelectView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 30/05/2022.
//

import SwiftUI

struct DeviceSelectView: View {
    
    @Binding var selectedDevice: Device
    
    @EnvironmentObject var userPrefs: UserPrefs
    
    func devices(for category: DeviceCategory) -> [Device] {
        category.devices().filter { userPrefs.userOwnedDevices.contains($0) }
    }
    
    var body: some View {
        
        VStack {
            
            List {
                
                ForEach(DeviceCategory.allCases) { category in
                    
                    if !devices(for: category).isEmpty {
                        
                        Section(header: Text(category.displayName)) {
                            
                            ForEach(devices(for: category)) { device in
                                
                                HStack {
                                    Image(systemName: "checkmark")
                                        .opacity(selectedDevice == device ? 1 : 0)
                                    
                                    Text(device.displayName)
                                }
                                .onTapGesture {
                                    selectedDevice = device
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


struct DeviceSelectView_Previews: PreviewProvider {
    
    static var previews: some View {
        DeviceSelectView(selectedDevice: .constant(.DTR))
            .environmentObject(UserPrefs(forTest: true))
    }
}
