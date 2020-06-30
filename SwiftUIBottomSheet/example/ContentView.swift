//
//  ContentView.swift
//  SwiftUIBottomSheet
//
//  Created by Jakub Charvat on 29/06/2020.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.08, longitude: 14.43), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        MapView()
            .overlay(BottomSheet {
                OverlayContent()
            } header: {
                OverlaySearch()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
