//
//  BottomSheetScrollView.swift
//  SwiftUIBottomSheet
//
//  Created by Jakub Charvat on 27/06/2020.
//

import SwiftUI

struct BottomSheetScrollView<Content>: View where Content: View {
    let content: () -> Content
    let contentHeight: Binding<CGFloat>
    let contentOffset: CGFloat
    
    
    init(contentHeight: Binding<CGFloat>, contentOffset: CGFloat, content: @escaping () -> Content) {
        self.content = content
        self.contentHeight = contentHeight
        self.contentOffset = contentOffset
    }
    
    var body: some View {
        GeometryReader { proxy in
            content()
                .modifier(ContentHeightKey())
                .offset(y: contentOffset)
                .frame(height: proxy.size.height, alignment: .top)
                .clipped()
        }
        .onPreferenceChange(ContentHeightKey.self) { value in
            print("ContentHeight", value)
            contentHeight.wrappedValue = value
        }
    }
}

struct DraggyScrollView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetScrollView(contentHeight: .constant(200), contentOffset: 10) {
            VStack {
                ForEach(0..<100) { index in
                    Text("Row \(index)")
                        .frame(height: 40)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}


//MARK: - Intrinsic Height
struct ContentHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}


extension ContentHeightKey: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                Color.clear.preference(key: Self.self, value: proxy.size.height)
            })
    }
}
