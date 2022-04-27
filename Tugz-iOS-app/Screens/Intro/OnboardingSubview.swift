//
//  OnboardingSubview.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 27/04/2022.
//

import SwiftUI

struct OnboardingSubview: View {
    
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
    }
}

struct OnboardingSubview_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSubview(imageName: "LaunchScreen")
    }
}
