# StringExtensions

Small `String` helpers focused on text sizing for UIKit layouts.

## What’s included
- `StringExtensions.swift` — `sizeWithFont(font:forWidth:)` to calculate bounding size for a string given a font and maximum width.

## Highlights
- Uses `boundingRect` with word wrapping for predictable multiline sizing.
- Returns `CGSize` you can use for manual layout or dynamic cell sizing.
- No external dependencies; just Foundation + UIKit.

## Requirements
- Platforms: iOS 13+.
- Swift: 5.7+

## Installation
- Manual: copy `StringExtensions.swift` into your target.
- Swift Package Manager: not yet published; manual copy recommended for now.

## Usage
```swift
import UIKit

let maxWidth: CGFloat = 200
let labelFont = UIFont.preferredFont(forTextStyle: .body)
let measured = "Hello, world!".sizeWithFont(font: labelFont, forWidth: maxWidth)
```

## Notes
- The method uses `.byWordWrapping` and `.usesLineFragmentOrigin`; supply the width you expect in your layout to get a matching height/width result.

