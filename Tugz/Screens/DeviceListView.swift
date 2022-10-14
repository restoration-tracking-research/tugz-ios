//
//  DeviceListView.swift
//  Tugz
//
//  Created by Charlie Williams on 18/04/2022.
//

import SwiftUI

/*
 1. A screen that says "which devices do you own"
 2. When you start a session there's a list of just the devices you own, plus manual methods
 */

struct DeviceListView: View {
    
    @EnvironmentObject var userPrefs: UserPrefs
    
    var body: some View {
        
        VStack {
            
            List {
                
                ForEach(DeviceCategory.allCases) { category in
                    
                    Section(header: Text(category.displayName)) {
                        
                        ForEach(category.devices()) { device in
                            
                            HStack {
                                
                                Image(systemName: "checkmark")
                                    .opacity(userPrefs.userOwnedDevices.contains(device) ? 1 : 0)
                                
                                Text(device.displayName)
                                Spacer()
                            }
                            .padding()
//                            .background(.red)
                            .onTapGesture {
                                if userPrefs.userOwnedDevices.contains(device) {
                                    userPrefs.userOwnedDevices = userPrefs.userOwnedDevices.filter { $0 != device }
                                } else {
                                    userPrefs.userOwnedDevices.append(device)
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
        DeviceListView()
            .environmentObject(UserPrefs(forTest: true))
    }
}
