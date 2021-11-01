//
//  Indicator.swift
//  Images and Coordinates
//
//  Created by Carmen Morado on 10/28/21.
//

import SwiftUI

struct Indicator : UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
