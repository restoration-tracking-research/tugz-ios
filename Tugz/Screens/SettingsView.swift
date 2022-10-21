//
//  SettingsView.swift
//  Tugz
//
//  Created by Charlie Williams on 21/10/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var config: Config
    
    var body: some View {
        
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 12) {
                TugScheduleView(prefs: config.prefs)
                    .environmentObject(config.prefs)
                
                NavigationLink(destination: {
                    DeviceListView()
                        .environmentObject(config.prefs)
                        .navigationBarTitle(Text("My Devices"))

                }, label: {
                    
                    ZStack {
    
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(height: 44)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Text("My Devices")
                                .background(.white)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 55)
                    })
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Config(forTest: true))
    }
}
