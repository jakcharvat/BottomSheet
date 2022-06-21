# SwiftUI Bottom Sheet

A basic, pure SwiftUI ([mostly](#mostlySwiftUI)), implementation of the bottom sheet seen in many of Apple's apps, such as Maps or Stocks. This is a very rough implementation, so I'd appreciate all help I can get. If you'd like to help me out, don't hesitate to submit issues and/or PRs against this repo or [reach out to me via email](mailto:jakcharvat@gmail.com).



## Getting Started

To get started, check out the [getting started](https://github.com/jakcharvat/SwiftUIBottomSheet/wiki/Getting-Started) section in the wiki.



## Example View

```swift
import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.08, longitude: 14.43), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var search = ""
    
    var body: some View {
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
```
![Sample App running on an iPhone 11 simulator](https://lh3.googleusercontent.com/K_CR33btTdbGoM9X3ucgokYRPgDXi8-Kpdy4fMVTwNeuMoVOKCy-4dPmfNtQduEnZ4sE_hWbTBp0ny9FBFQGnMPBu2X8KW06FTGhsWGDGeLOKkPQbKip6ucQcLFmZVQnqSmRLTEc7kU=w2400?source=screenshot.guru)


<a name="mostlySwiftUI"></a>

## Pure SwiftUI (mostly)

All the main content of this view is written purely using SwiftUI, however there is one small exception to that rule. I use a `UIViewRepresantable` to bridge a native UIKit `UIVisualEffectView` to SwiftUI, just to be able to use the blur effect `UIVisualEffectView` brings.



