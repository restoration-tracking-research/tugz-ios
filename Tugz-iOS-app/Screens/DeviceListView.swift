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
    
    @Binding var selectedDevice: [Device]
    
    var body: some View {
        
        VStack {
            List {
                ForEach(DeviceCategory.allCases) { category in
                    
                    Section(header: Text(category.displayName)) {
                        
                        ForEach(category.devices()) { device in
                            
                            Text(device.displayName)
                        }
                    }
                }
            }
        }
    }
}

struct DeviceListView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceListView(selectedDevice: Binding(projectedValue: .constant([.Foreskinned_Workhorse])))
    }
}
