//
//  NeedLoginView.swift
//  Tugz
//
//  Created by Charlie Williams on 06/06/2022.
//

import SwiftUI

struct NeedLoginView: View {
    
    var body: some View {
        
        ZStack {
            
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            Image(systemName: "t.circle.fill")
                .font(.system(size: 500, weight: .heavy))
                .frame(width: 150, height: 150)
                .foregroundColor(.accentColor)
                .position(x: 80, y: 200)
                .opacity(0.3)
            
            VStack(alignment: .leading, spacing: 22) {
                
                Text("Save your history")
                    .font(.largeTitle).bold()
                
                
                
                Text("To save your history and sync it across devices, please use your Apple ID to log in to your iCloud account.")
                    .font(.title)
                
                Text("All your data remains completely private unless you choose to share anonymous information about your progress.")
                    .font(.body)
                
                HStack(alignment: .center) {
                    Button("Log in now") {
                        guard let url = URL(string: UIApplication.openSettingsURLString),
                              UIApplication.shared.canOpenURL(url) else {
                            return
                        }
                        
                        UIApplication.shared.open(url)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
}

struct NeedLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NeedLoginView()
    }
}
