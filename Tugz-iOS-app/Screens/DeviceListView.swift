//
//  DeviceListView.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 18/04/2022.
//

import SwiftUI

/*
 1. A screen that says "which devices do you own"
 2. When you start a session there's a list of just the devices you own, plus manual methods
 */

struct DeviceListView: View {
    
    @Binding var selectedDevice: Device
    
    @State var onlyShowOwned: Bool
    
    @EnvironmentObject var userPrefs: UserPrefs
    
    func devices(for category: DeviceCategory) -> [Device] {
        category.devices().filter { onlyShowOwned ? userPrefs.userOwnedDevices.contains($0) : true }
    }
    
    var body: some View {
        
        VStack {
            
            List {
                
                ForEach(DeviceCategory.allCases) { category in
                    
                    if !devices(for: category).isEmpty {
                        
                        Section(header: Text(category.displayName)) {
                            
                            ForEach(devices(for: category)) { device in
                                
                                Text(device.displayName)
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

struct DeviceListView_Previews: PreviewProvider {
    
    static var previews: some View {
        DeviceListView(selectedDevice: Binding(projectedValue: .constant(.Foreskinned_Workhorse)), onlyShowOwned: true)
            .environmentObject(UserPrefs(forTest: true))
        
        DeviceListView(selectedDevice: Binding(projectedValue: .constant(.Foreskinned_Workhorse)), onlyShowOwned: false)
            .environmentObject(UserPrefs(forTest: true))
    }
}
