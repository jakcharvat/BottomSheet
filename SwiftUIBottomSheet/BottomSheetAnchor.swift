//
//  BottomSheetAnchor.swift
//  SwiftUIBottomSheet
//
//  Created by Jakub Charvat on 28/06/2020.
//

import SwiftUI


//MARK: - Container
struct BottomSheetAnchorContainer<Content, KeyType>: View where Content: View, KeyType: BottomSheetAnchorKey, KeyType.Value == [CGPoint] {

    let content: Content
    let onAnchorUpdate: (KeyType.Value) -> ()
    let keyType: KeyType.Type
    
    private init() { fatalError("Don't use") }
    
    var body: some View {
        GeometryReader { (proxy: GeometryProxy) in
            content
                .onPreferenceChange(KeyType.self) { positions in
                    let origin = proxy.frame(in: .global).origin
                    let containerRelativePositions = positions.map { CGPoint(x: $0.x - origin.x, y: $0.y - origin.y)}
                    onAnchorUpdate(containerRelativePositions)
                }
        }
    }
}


//MARK: Initializers
extension BottomSheetAnchorContainer {
    init(for keyType: KeyType.Type, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.keyType = keyType
        onAnchorUpdate = { _ in }
    }
    
    init(for keyType: KeyType.Type, @ViewBuilder content: () -> Content, positionsHandler: @escaping (KeyType.Value) -> ()) {
        self.content = content()
        self.keyType = keyType
        onAnchorUpdate = positionsHandler
    }
}


extension BottomSheetAnchorContainer where KeyType == BottomSheetDefaultAnchorKey {
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.keyType = BottomSheetDefaultAnchorKey.self
        onAnchorUpdate = { _ in }
    }
    
    init(@ViewBuilder content: () -> Content, positionsHandler: @escaping (KeyType.Value) -> ()) {
        self.content = content()
        self.keyType = BottomSheetDefaultAnchorKey.self
        onAnchorUpdate = positionsHandler
    }
}



//MARK: - Anchor
struct BottomSheetAnchor<KeyType>: View where KeyType: BottomSheetAnchorKey {
    let keyType: KeyType.Type
    
    var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .background(GeometryReader { (proxy: GeometryProxy) in
                Color.clear.preference(key: KeyType.self, value: [proxy.frame(in: .global).origin] as! KeyType.Value)
            })
    }
}

extension BottomSheetAnchor where KeyType == BottomSheetDefaultAnchorKey {
    init() {
        keyType = BottomSheetDefaultAnchorKey.self
    }
}


//MARK: Visibility
extension BottomSheetAnchor {
    func visibility(_ visibility: Visibility) -> some View {
        let isVisible: Bool
        
        switch visibility {
        case .never:
            isVisible = false
        case .always:
            isVisible = true
        case .simulator:
            #if targetEnvironment(simulator)
            isVisible = true
            #else
            isVisible = false
            #endif
        case .debug:
            #if DEBUG
            isVisible = true
            #else
            isVisible = false
            #endif
        case .simulatorAndDebug:
            #if DEBUG
            isVisible = true
            #elseif targetEnvironment(simulator)
            isVisible = true
            #else
            isVisible = false
            #endif
        }
        
        return visible(isVisible)
    }
    
    private func visible(_ visible: Bool = true) -> some View {
        return self
            .overlay(Color.gray.frame(width: visible ? 10 : 0, height: visible ? 10 : 0))
    }
    
    enum Visibility {
        case never, always, simulator, debug, simulatorAndDebug
    }
}


//MARK: - Anchor Keys
protocol BottomSheetAnchorKey: PreferenceKey {}
extension BottomSheetAnchorKey {
    static var defaultValue: [CGPoint] { [] }
    
    static func reduce(value: inout [CGPoint], nextValue: () -> [CGPoint]) {
        value += nextValue()
    }
}

struct BottomSheetDefaultAnchorKey: BottomSheetAnchorKey { }
