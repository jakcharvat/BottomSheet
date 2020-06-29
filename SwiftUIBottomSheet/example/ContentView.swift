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
    @State private var search = ""
    
    var body: some View {
//        MapView()
//            .overlay(BottomSheet {
//                OverlayContent()
//            } header: {
//                OverlaySearch()
//            })
        
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
                .overlay(BottomSheet {
                    VStack {
                        ForEach(0 ..< 100) { i in
                            Text("Row \(i)")
                                .frame(height: 44)
                            
                            if [2, 4, 10].contains(i) {
                                VStack(spacing: 0) {
                                    BottomSheetAnchor()
                                    Color(.separator)
                                        .frame(height: 1)
                                }
                            }
                        }
                    }
                } header: {
                    TextField("\(Image(systemName: "magnifyingglass")) Search for a place or address", text: $search)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding([.horizontal, .bottom])
                })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
