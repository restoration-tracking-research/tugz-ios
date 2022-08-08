//
//  PhotoGallery.swift
//  Tugz
//
//  Created by Charlie Williams on 18/04/2022.
//

import SwiftUI

struct PhotoGallery: View {
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var photos: [Photo] = []
    
    private let threeColumnLayout = [GridItem(.flexible()),
                                     GridItem(.flexible()),
                                     GridItem(.flexible())]
    
    var view: some View {
        
        ScrollView {
            LazyVGrid (columns: threeColumnLayout) {
                ForEach(photos) { photo in
                    
                }
            }
        }
    }
    
}

struct PhotoGallery_Previews: PreviewProvider {
    
    static var previews: some View {
        PhotoGallery()
    }
}
