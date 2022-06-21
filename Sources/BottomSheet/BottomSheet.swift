//
//  BottomSheet.swift
//  SwiftUIBottomSheet
//
//  Created by Jakub Charvat on 27/06/2020.
//

import SwiftUI


struct BottomSheetState {
    /// The current height of the sheet
    var containerHeight: CGFloat = -1
    /// The height of the sheet before the start of the latest drag, used for animation purposes
    var startContainerHeight: CGFloat = -1
    
    /// The height of the scrollable content
    var contentHeight: CGFloat = -1
    
    /// The current offset (scroll amount) of the content within the [DraggyScrollView]
    var contentOffset: CGFloat = 0
    /// The offset of the content before the start of the latest drag, used for animation purposes
    var startContentOffset: CGFloat = 0
    
    /// Used to hide the content in the header-only view
    var isMainContentShown = false
    
    var headerHeight: CGFloat = -1
    var anchorStops: [CGFloat] = []
    var fixedStops: [CGFloat] = []
}


public struct BottomSheet<MainContent, HeaderContent, KeyType>: View where MainContent: View, HeaderContent: View, KeyType: BottomSheetAnchorKey, KeyType.Value == [CGPoint] {
    private let content: MainContent
    private let header: HeaderContent
    private let keyType: KeyType.Type
    
    private let shouldUseAnchors: Bool
    
    var stops: [CGFloat] {
        if shouldUseAnchors {
            return [state.headerHeight] + state.anchorStops
        } else {
            return [state.headerHeight] + state.fixedStops
        }
    }
    
    private init() { fatalError("Don't use") }
    
    @State private var state = BottomSheetState()
    
    
    //MARK: Body
    public var body: some View {
        GeometryReader { (proxy: GeometryProxy) in
            VStack(spacing: 0) {
                Group {
                    HStack {
                        Capsule().fill(Color(.separator))
                            .frame(width: 44, height: 6)
                    }
                    .padding(.vertical, 6)
                    
                    header
                }
                .modifier(HeaderHeightKey())
                
                BottomSheetScrollView(contentHeight: $state.contentHeight, contentOffset: state.contentOffset) {
                    content
                        .opacity(state.isMainContentShown ? 1 : 0)
                        .onPreferenceChange(keyType.self) { positions in
                            let offset = proxy.size.height - state.containerHeight
                            let heights = positions.map { $0.y }
                            let sheetRelativeHeights = heights.map { $0 - offset - proxy.safeAreaInsets.bottom }
                            state.anchorStops = sheetRelativeHeights
                        }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .frame(height: state.containerHeight + proxy.safeAreaInsets.bottom, alignment: .top)
            .background(
                ZStack {
                    Color(.systemBackground).opacity(0.8)
                    VisualEffectView(with: UIBlurEffect(style: .regular))
                }
                .edgesIgnoringSafeArea(.all)
            )
            .cornerRadius(20)
            .offset(y: proxy.size.height - state.containerHeight)
            .gesture(DragGesture().onChanged { data in
                onDragChange(data: data, proxy: proxy)
            }.onEnded { data in
                onDragEnd(data: data, proxy: proxy)
            })
            .onPreferenceChange(HeaderHeightKey.self) { height in
                state.headerHeight = height
            }
            .onAppear {
                state.containerHeight = stops[0]
                state.startContainerHeight = stops[0]
            }
        }
    }
    
    
    //MARK: On Drag Change
    /// Update container height and content offset based on the ongoing drag gesture
    /// - Parameters:
    ///   - data: The drag gesture value
    ///   - proxy: Geometry Proxy defining the available viewport
    func onDragChange(data: DragGesture.Value, proxy: GeometryProxy) {
        let translation = data.translation.height
        
        let shouldScrollContent = state.containerHeight >= proxy.size.height && state.startContentOffset + translation < 0
        if shouldScrollContent {
            let heightDelta = state.startContainerHeight - state.containerHeight
            state.contentOffset = state.startContentOffset + (translation - heightDelta)
            
            return
        }
        
        state.contentOffset = 0
        state.containerHeight = min(state.startContainerHeight - state.startContentOffset - translation, proxy.size.height)
        
        withAnimation(.easeInOut) {
            state.isMainContentShown = state.containerHeight >= stops[0] + 10
        }
    }
    
    
    //MARK: On Drag End
    /// Calculate and animate to the target sheet height and content offset based on the current position and drag velocity
    /// - Parameters:
    ///   - data: The drag gesture value
    ///   - proxy: Geometry Proxy defining the available viewport
    func onDragEnd(data: DragGesture.Value, proxy: GeometryProxy) {
        onDragChange(data: data, proxy: proxy)
        
        let offsetDelta = state.contentOffset - state.startContentOffset
        let heightDelta = state.containerHeight - state.startContainerHeight
        
        
        // Only the scrollview should scroll with no change to the sheet's position
        if heightDelta == 0 {
            let targetOffset = -(state.startContentOffset + data.predictedEndTranslation.height)
            let endOffset = -max(0, min(state.contentHeight - proxy.size.height + state.headerHeight, targetOffset))
            
            withAnimation(.spring()) {
                state.contentOffset = endOffset
                state.startContentOffset = state.contentOffset
            }
            
            return
        }
        
        // Adjust the position of the sheet
        let stopsWithHeight = stops + [proxy.size.height]
        
        let predictedHeight = state.startContainerHeight - state.startContentOffset - (data.predictedEndTranslation.height + offsetDelta)
        let targetDiffs = stopsWithHeight.map { abs($0 - predictedHeight) }
        let targetPositionIndex = targetDiffs.enumerated().min { $0.element < $1.element }!.offset
        let targetHeight = stopsWithHeight[targetPositionIndex]
        
        withAnimation(.spring()) {
            state.containerHeight = targetHeight
        }
        
        state.startContainerHeight = targetHeight
        state.startContentOffset = state.contentOffset
        
        withAnimation(.easeInOut) {
            state.isMainContentShown = state.containerHeight >= stops[0] + 10
        }
    }
}


//MARK: - Initializers
public extension BottomSheet where HeaderContent == Text, KeyType == BottomSheetDefaultAnchorKey {
    //MARK: Title and content
    /// This initializer creates an instance of the `BottomSheet` struct with the given title string and content.
    ///
    /// You can use the `BottomSheetAnchor` elements with no custom key inside the content to define stops for the bottom sheet (the bottom sheet will stop at the height needed to make the anchor just visible).
    ///
    /// This sheet uses the default `BottomSheetDefaultActionKey` key for its anchors, so it may clash with other `BottomSheet` instances if you're using more than one.
    ///
    /// To avoid the clash it's recommended to use the `init(title:key:content:)` initializer, providing a custom key to uniquely identify the anchors belonging to this `BottomSheet` instance. You must then pass the same key to all the `BottomSheetAnchor` elements used within this sheet.
    /// - Parameters:
    ///   - title: The title to be displayed in the header of the sheet
    ///   - content: The main content of the sheet
    init(_ title: String, content: () -> MainContent) {
        self.content = content()
        header = Text(title)
            .font(.title)
        keyType = BottomSheetDefaultAnchorKey.self
        shouldUseAnchors = true
    }
    
    //MARK: Title, stops and content
    /// This initializer creates an instance of the `BottomSheet` struct with the given title string, stops  and content.
    ///
    /// Use this initializer if you don't want to leave calculating the stop positions up to the `BottomSheet` and rather want to provide point-based values yourself. The stops represent the content heights the sheet should snap to and are specified in points from the top of the main content (excluding the title).
    /// - Parameters:
    ///   - title: The title to be displayed in the header of the sheet
    ///   - stops: The content heights the sheet should snap to and are specified in points from the top of the main content (excluding the title)
    ///   - content: The main content of the sheet
    init(_ title: String, stops: [CGFloat], content: () -> MainContent) {
        self.content = content()
        header = Text(title)
            .font(.title)
        keyType = BottomSheetDefaultAnchorKey.self
        shouldUseAnchors = false
        state.fixedStops = stops
    }
}

public extension BottomSheet where HeaderContent == Text {
    //MARK: Title, key and content
    /// This initializer creates an instance of the `BottomSheet` struct with the given title string, key and content.
    ///
    /// Use this initializer to ensure multiple bottom sheets and their anchors don't clash. The key provided in this initializer be also provided in the initializers on all `BottomSheetAnchor` elements this view should use when calculating its stops.
    /// - Parameters:
    ///   - title: The title to be displayed in the header of the sheet
    ///   - key: The key to uniquely identify the anchors belonging to this sheet
    ///   - content: The main content of the sheet
    init(_ title: String, key: KeyType.Type, content: () -> MainContent) {
        self.content = content()
        header = Text(title)
            .font(.title)
        keyType = key
        shouldUseAnchors = true
    }
}

public extension BottomSheet where KeyType == BottomSheetDefaultAnchorKey {
    //MARK: Content and header
    /// This initializer creates an instance of the `BottomSheet` struct with the given content and header view.
    ///
    /// You can use the `BottomSheetAnchor` elements with no custom key inside the content to define stops for the bottom sheet (the bottom sheet will stop at the height needed to make the anchor just visible).
    ///
    /// This sheet uses the default `BottomSheetDefaultActionKey` key for its anchors, so it may clash with other `BottomSheet` instances if you're using more than one.
    ///
    /// To avoid the clash it's recommended to use the `init(title:key:content:)` initializer, providing a custom key to uniquely identify the anchors belonging to this `BottomSheet` instance. You must then pass the same key to all the `BottomSheetAnchor` elements used within this sheet.
    /// - Parameters:
    ///   - content: The main content of the sheet
    ///   - header: The view to be displayed in the header section of the sheet
    init(content: () -> MainContent, header: () -> HeaderContent) {
        self.content = content()
        self.header = header()
        keyType = BottomSheetDefaultAnchorKey.self
        shouldUseAnchors = true
    }
    
    //MARK: Stops, content and header
    /// This initializer creates an instance of the `BottomSheet` struct with the given stops, content and header view.
    ///
    /// Use this initializer if you don't want to leave calculating the stop positions up to the `BottomSheet` and rather want to provide point-based values yourself. The stops represent the content heights the sheet should snap to and are specified in points from the top of the main content (excluding the title).
    /// - Parameters:
    ///   - stops: The content heights the sheet should snap to and are specified in points from the top of the main content (excluding the title)
    ///   - content: The main content of the sheet
    ///   - header: The view to be displayed in the header section of the sheet
    init(stops: [CGFloat], content: () -> MainContent, header: () -> HeaderContent) {
        self.content = content()
        self.header = header()
        keyType = BottomSheetDefaultAnchorKey.self
        shouldUseAnchors = false
        state.fixedStops = stops
    }
}

public extension BottomSheet {
    //MARK: Key, content and header
    /// This initializer creates an instance of the `BottomSheet` struct with the given key, content and header view.
    ///
    /// Use this initializer to ensure multiple bottom sheets and their anchors don't clash. The key provided in this initializer be also provided in the initializers on all `BottomSheetAnchor` elements this view should use when calculating its stops.
    /// - Parameters:
    ///   - key: The key to uniquely identify the anchors belonging to this sheet
    ///   - content: The main content of the sheet
    ///   - header: The view to be displayed in the header section of the sheet
    init(key: KeyType.Type, content: () -> MainContent, header: () -> HeaderContent) {
        self.content = content()
        self.header = header()
        keyType = key
        shouldUseAnchors = true
    }
}


//MARK: - Header Height
struct HeaderHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}


extension HeaderHeightKey: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(GeometryReader { (proxy: GeometryProxy) in
                Color.clear.preference(key: Self.self, value: proxy.size.height)
            })
    }
}
