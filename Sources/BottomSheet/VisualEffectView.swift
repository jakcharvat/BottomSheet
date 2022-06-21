//
//  VisualEffectView.swift
//  SwiftUIBottomSheet
//
//  Created by Jakub Charvat on 27/06/2020.
//

import SwiftUI
import UIKit

struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    
    init(with effect: UIVisualEffect = UIBlurEffect(style: .systemMaterial)) {
        self.effect = effect
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct VisualEffectView_Previews: PreviewProvider {
    static var previews: some View {
        VisualEffectView()
    }
}
