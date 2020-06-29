//
//  OverlayContent.swift
//  SwiftUIBottomSheet
//
//  Created by Jakub Charvat on 27/06/2020.
//

import SwiftUI

//MARK: - Overlay
struct OverlayContent: View {
    var body: some View {
        VStack(spacing: 20) {
            FavouritesView()
            BottomSheetAnchor()
            CollectionsView()
            BottomSheetAnchor()
            RecentsView()
        }
    }
}


//MARK: - Search
struct OverlaySearch: View {
    @State private var search = ""
    
    var body: some View {
        TextField("\(Image(systemName: "magnifyingglass")) Search for a place or address", text: $search)
            .padding(8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding([.horizontal, .bottom])
    }
}


//MARK: - Title View
struct TitleView: View {
    let title: String
    let showButton: Bool
    
    init(_ title: String, showButton: Bool = true) {
        self.title = title
        self.showButton = showButton
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(title)
                    .foregroundColor(.secondary)
                Spacer()
                if showButton { Button("See All") { } }
            }
            .padding(.trailing)
            
            Separator()
        }
        .padding(.leading)
    }
}


//MARK: - Separator
struct Separator: View {
    var body: some View {
        Color(.separator)
            .frame(height: 1)
    }
}


//MARK: - Icon View
struct IconView: View {
    let iconName: String
    let title: String
    let subtitle: String?
    
    init(iconName: String, title: String, subtitle: String? = nil) {
        self.iconName = iconName
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding(20)
                .background(
                    Circle()
                        .fill(Color(.systemFill))
                )
                
            Text(title)
                .font(.title3)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .foregroundColor(.secondary)
            }
        }
    }
}


//MARK: - Favourites View
struct FavouritesView: View {
    var body: some View {
        VStack(spacing: 15) {
            TitleView("Favourites")
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 30) {
                    IconView(iconName: "house.fill", title: "Home", subtitle: "Add")
                    IconView(iconName: "latch.2.case.fill", title: "Work", subtitle: "Add")
                    IconView(iconName: "plus", title: "Add")
                }
                .padding(.horizontal)
            }
        }
    }
}


//MARK: - Collections View
struct CollectionsView: View {
    var body: some View {
        VStack(spacing: 12) {
            TitleView("Collections", showButton: false)
                
            VStack(alignment: .leading) {
                CollectionRow(imageName: "square.fill.on.square.fill", title: "My Places", subtitle: "4 Places")
                Separator()
                CollectionRow(imageName: "square.fill.on.square.fill", title: "Vyšší Brod", subtitle: "4 Places")
                Separator()
                CollectionRow.newCollection
            }
            .padding(.leading)
        }
    }
}


//MARK: - Collection Row
struct CollectionRow: View {
    let imageName: String
    let titleView: Text
    let subtitleView: Text?
    let imageForegroundColor: Color
    
    init(imageName: String, title: String, subtitle: String) {
        self.imageName = imageName
        self.titleView = Text(title)
            .font(.title2)
            .fontWeight(.medium)
        self.subtitleView = Text(subtitle)
            .foregroundColor(.secondary)
        self.imageForegroundColor = .primary
    }
    
    private init(imageName: String, titleView: Text) {
        self.imageName = imageName
        self.titleView = titleView
        self.subtitleView = nil
        self.imageForegroundColor = Color(.systemFill)
    }
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(imageForegroundColor)
                .font(.system(size: 64))
                .padding(.trailing)
            
            VStack {
                titleView
                if let subtitleView = subtitleView {
                    subtitleView
                }
            }
        }
    }
    
    static let newCollection: CollectionRow = CollectionRow(imageName: "square.on.square.fill", titleView: Text("New Collection...").font(.title2).foregroundColor(.blue))
}


//MARK: - Recents View
struct RecentsView: View {
    var body: some View {
        VStack(spacing: 0) {
            TitleView("Recently Viewed")
            RecentsRow(imageName: "mappin", color: .red, title: "Marked Location", subtitle: "Pod Brushou 147/3, Prague")
            RecentsRow(imageName: "mappin", color: .red, title: "Jičín", subtitle: "Hradec Králové")
            RecentsRow(imageName: "stethoscope", color: .pink, title: "Asklepion", subtitle: "Londýnská 160/39, Prague")
            RecentsRow(imageName: "tram.fill", color: .blue, title: "Karlovo náměstí", subtitle: "Prague")
            RecentsRow(imageName: "arrow.triangle.branch", color: .gray, title: "K Mazínu", subtitle: "Directions from Okružní")
            RecentsRow(imageName: "tram.fill", color: .blue, title: "Sídliště Řepy Stop", subtitle: "Prague")
            RecentsRow(imageName: "arrow.triangle.branch", color: .gray, title: "Sídliště Řepy Stop", subtitle: "Directions from My Location")
        }
    }
}


//MARK: - Recents Row
struct RecentsRow: View {
    let imageName: String
    let color: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(Color(.systemBackground))
                    .padding()
                    .background(Circle().fill(color))
                    .frame(width: 42, height: 42, alignment: .center)
                    .clipped()
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text(subtitle)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical)
            
            Separator()
        }
        .padding(.leading)
    }
}


//MARK: - Previews
struct OverlayContent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OverlayContent()
                
            TitleView("Title")
                .previewLayout(.sizeThatFits)
            IconView(iconName: "house.fill", title: "Home", subtitle: "Add")
                .previewLayout(.sizeThatFits)
        }
    }
}
