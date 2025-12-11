# UIViewExtensions

Styling helpers for `UIView` that make rounding corners, adding borders, and applying shadows concise and chainable.

## What’s included
- `UIView+Styling.swift` — helpers to round corners, make circular views, set borders, and apply configurable shadows.

## Highlights
- Chainable API for concise styling code.
- Circle helper uses the smallest dimension for perfect circles (call after layout).
- Shadow helper sets `masksToBounds = false` and accepts color, opacity, blur radius, and offset.
- Border helper configures width and color in one call.

## Requirements
- Platforms: iOS 13+.
- Swift: 5.7+

## Installation
- Manual: copy `UIView+Styling.swift` into your target.
- Swift Package Manager: not yet published; manual copy recommended for now.

## Usage
```swift
import UIKit

// Round all corners
cardView.roundCorners(radius: 12)

// Make a circle (after layout)
avatarImageView.roundAsCircle()

// Add a border
badgeView.setBorder(width: 2, color: .systemBlue)

// Add a shadow
cardView.setShadow(
    color: .black,
    opacity: 0.25,
    radius: 6,
    offset: CGSize(width: 0, height: 3)
)
```

## Notes
- Rounded corners + shadow: wrap content in a container; apply `roundCorners` to the inner view and `setShadow` to the outer container so `masksToBounds` requirements don’t conflict.
- `roundAsCircle()` should be called after layout so the view has its final size.

