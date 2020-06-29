# SwiftUI Bottom Sheet

A basic, pure SwiftUI ([mostly](#mostlySwiftUI)), implementation of the bottom sheet seen in many of Apple's apps, such as Maps or Stocks. This is a very rough implementation, so I'd appreciate all help I can get. If you'd like to help me out, don't hesitate to submit issues and/or PRs against this repo or [reach out to me via email](mailto:jakcharvat@gmail.com).



## Usage

I haven't been able to figure out how to package this thing as a Swift Package (yet!), so for now if you want to use this package you'll have to add it to your project yourself. Clone or download this repo, then copy the contents of the `src` folder to your project.

Next, all you have to do to make the sheet appear on your screen is using one of the [initializers](#initializers) of the `BottomSheet` struct and passing it to SwiftUI's `overlay(_:)` modifier on the view you'd like to display the sheet over:

```swift
struct ContentView: View {
    var body: some View {
        MyMainView()
            .overlay(
                // Bottom Sheet initializer goes here
                ...
            )
    }
}
```

---
<a name="initializers"></a>
## Initializers
`BottomSheet` offers six different initializers that vary in purpose. The easiest to get started is probably [`init(_:stops:content:)`](#initStopsContent). 

<a name="initContent"></a>

### `init(_:content:)`

This initializer creates an instance of the `BottomSheet` struct with the given title string and content.

You should use the `BottomSheetAnchor` elements with no custom key inside the content to define stops for the bottom sheet (the bottom sheet will stop at the height needed to make the anchor just visible).

This sheet uses the default `BottomSheetDefaultActionKey` key for its anchors, so it may clash with other `BottomSheet` instances if you're using more than one.

To avoid the clash you should use the `init(title:key:content:)` initializer, providing a custom key to uniquely identify the anchors belonging to this `BottomSheet` instance. You must then pass the same key to all the `BottomSheetAnchor` elements used within this sheet.

If you'd like to customize the appearance of the header, use the sibling [`init(content:header:)`](#initContentHeader) initializer.

#### Signature:
```swift
init(_ title: String, content: () -> MainContent)
```
#### Params:
- **title**: The title to be displayed in the header of the sheet
- **content**: The main content of the sheet

#### Example:
```swift
BottomSheet("This is my sheet") {
    Text("This is the content of the sheet")
        .frame(width: 100, height: 100)
    BottomSheetAnchor()
    Text("This text comes below the anchor")
        .frame(width: 100, height: 100)
}
```

<a name="initStopsContent"></a>

### `init(_:stops:content:)`
This initializer creates an instance of the `BottomSheet` struct with the given title string, stops and content.

Use this initializer if you don't want to leave calculating the stop positions up to the `BottomSheet` and rather want to provide point-based values yourself. The stops represent the content heights the sheet should snap to and are specified in points from the top of the main content (excluding the title).

If you'd like to customize the appearance of the header, use the sibling [`init(stops:content:header:)`](#initStopsContentHeader) initializer.

#### Signature:
```swift
init(_ title: String, stops: [CGFloat], content: () -> MainContent)
```
#### Params:
- **title**: The title to be displayed in the header of the sheet
- **stops**: The content heights the sheet should snap to and are specified in points from the top of the main content (excluding the title)
- **content**: The main content of the sheet

#### Example:
```swift
BottomSheet("This is my sheet", stops: [10, 20]) {
    Text("This is the content of the sheet")
        .frame(width: 100, height: 100)
}
```

<a name="initKeyContent"></a>

### `init(_:key:content:)`

This initializer creates an instance of the `BottomSheet` struct with the given title string, key and content.

Use this initializer to ensure multiple bottom sheets and their anchors don't clash. The key provided in this initializer be also provided in the initializers on all `BottomSheetAnchor` elements this view should use when calculating its stops.

If you'd like to customize the appearance of the header, use the sibling [`init(key:content:header:)`](#initKeyContentHeader) initializer.

#### Signature:
```swift
init(_ title: String, key: KeyType.Type, content: () -> MainContent)
```
#### Params:
- **title**: The title to be displayed in the header of the sheet
- **key**: The key to uniquely identify the anchors belonging to this sheet content (excluding the title)
- **content**: The main content of the sheet

#### Example:
```swift
struct MyKeyType: BottomSheetAnchorKey { }

BottomSheet("This is my sheet", key: MyKeyType.self) {
    Text("This is the content of the sheet")
        .frame(width: 100, height: 100)
    BottomSheetAnchor(key: MyKeyType.self)
    Text("This text comes below the anchor")
        .frame(width: 100, height: 100)
}
```

<a name="initContentHeader"></a>

### `init(content:header:)`

This initializer creates an instance of the `BottomSheet` struct with the given content and header view.

You should use the `BottomSheetAnchor` elements with no custom key inside the content to define stops for the bottom sheet (the bottom sheet will stop at the height needed to make the anchor just visible).

This sheet uses the default `BottomSheetDefaultActionKey` key for its anchors, so it may clash with other `BottomSheet` instances if you're using more than one.

To avoid the clash you should use the `init(title:key:content:)` initializer, providing a custom key to uniquely identify the anchors belonging to this `BottomSheet` instance. You must then pass the same key to all the `BottomSheetAnchor` elements used within this sheet.

[`init(_:content:)`](#initContent) is a simpler version of this initializer if you don't need a custom header and can afford to simply pass a title string to `BottomSheet` to be used for the header.

#### Signature:

```swift
init(content: () -> MainContent, header: () -> HeaderContent)
```

#### Params:

- **content**: The main content of the sheet
- **header**: The view to be displayed in the header section of the sheet

#### Example:

```swift
BottomSheet {
    Text("This is the content of the sheet")
        .frame(width: 100, height: 100)
    BottomSheetAnchor()
    Text("This text comes below the anchor")
        .frame(width: 100, height: 100)
} header: {
  	Text("This is my custom header")
  			.font(.largeTitle)
  			.fontWeight(.black)
}
```

<a name="initStopsContentHeader"></a>

### `init(stops:content:header:)`

This initializer creates an instance of the `BottomSheet` struct with the given stops, content and header view.

Use this initializer if you don't want to leave calculating the stop positions up to the `BottomSheet` and rather want to provide point-based values yourself. The stops represent the content heights the sheet should snap to and are specified in points from the top of the main content (excluding the title).

[`init(_:stops:content:)`](#initStopsContent) is a simpler version of this initializer if you don't need a custom header and can afford to simply pass a title string to `BottomSheet` to be used for the header.

#### Signature:

```swift
init(stops: [CGFloat], content: () -> MainContent, header: () -> HeaderContent)
```

#### Params:

- **stops**: The content heights the sheet should snap to and are specified in points from the top of the main content (excluding the title)
- **content**: The main content of the sheet
- **header**: The view to be displayed in the header section of the sheet

#### Example:

```swift
BottomSheet(stops: [10, 20]) {
    Text("This is the content of the sheet")
        .frame(width: 100, height: 100)
} header: {
  	Text("This is my custom header")
  			.font(.largeTitle)
  			.fontWeight(.black)
}
```

<a name="initKeyContentHeader"></a>

### `init(key:content:header:)`

This initializer creates an instance of the `BottomSheet` struct with the key, content and header view.

Use this initializer to ensure multiple bottom sheets and their anchors don't clash. The key provided in this initializer be also provided in the initializers on all `BottomSheetAnchor` elements this view should use when calculating its stops.

[`init(_:key:content:)`](#initKeyContent) is a simpler version of this initializer if you don't need a custom header and can afford to simply pass a title string to `BottomSheet` to be used for the header.

#### Signature:

```swift
init(key: KeyType.Type, content: () -> MainContent, header: () -> HeaderContent)
```

#### Params:

- **key**: The key to uniquely identify the anchors belonging to this sheet content (excluding the title)
- **content**: The main content of the sheet
- **header**: The view to be displayed in the header section of the sheet

#### Example:

```swift
struct MyKeyType: BottomSheetAnchorKey { }

BottomSheet(key: MyKeyType.self) {
    Text("This is the content of the sheet")
        .frame(width: 100, height: 100)
    BottomSheetAnchor(key: MyKeyType.self)
    Text("This text comes below the anchor")
        .frame(width: 100, height: 100)
} header: {
  	Text("This is my custom header")
  			.font(.largeTitle)
  			.fontWeight(.black)
}
```





<a name="mostlySwiftUI"></a>

## Pure SwiftUI (mostly)

All the main content of this view is written purely using SwiftUI, however there is one small exception to that rule. I use a `UIViewRepresantable` to bridge a native UIKit `UIVisualEffectView` to SwiftUI, just to be able to use the blur effect `UIVisualEffectView` brings.



