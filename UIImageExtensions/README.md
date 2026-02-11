# UIImageExtensions

Utilities for converting between UIImage and Base64 strings, plus a simple resize helper for UIKit.

## What’s included
- `UIImage+Base64.swift` — Encode/decode Base64 (PNG/JPEG) with optional data URL prefixes, and an aspect-fit resize helper.

## Highlights
- Encode as PNG or JPEG with configurable quality.
- Optionally include `data:image/...;base64,` prefix for web interop.
- Robust decoding: accepts plain Base64 or full data URL strings.
- Lightweight `resizeImage(_:opaque:contentMode:)` for aspect-fit scaling.
- No external dependencies; just Foundation + UIKit.

## Requirements
- Platforms: iOS 13+.
- Swift: 5.7+

## Installation
- Manual: copy `UIImage+Base64.swift` into your target.
- Swift Package Manager: not yet published; manual copy recommended for now.

## Usage
```swift
import UIKit

let image = UIImage(named: "example")!

// Encode to Base64 (JPEG with quality)
let jpegBase64 = image.base64EncodedString(as: .jpeg(quality: 0.8))

// Encode to Base64 (PNG)
let pngBase64 = image.base64EncodedString(as: .png)
// Include data URL prefix (useful for web)
let jpegDataURL = image.base64EncodedString(as: .jpeg(quality: 0.9), includeDataURLPrefix: true)
let pngDataURL = image.base64EncodedString(as: .png, includeDataURLPrefix: true)

// Decode from plain Base64
let decoded1 = someBase64String.imageFromBase64

// Decode from data URL (e.g., "data:image/png;base64,....")
let decoded2 = UIImage.fromBase64String("data:image/png;base64,\(someBase64String)")

// Get encoded data directly
let dataPNG = image.encodedData(as: .png)
let dataJPEG = image.encodedData(as: .jpeg(quality: 0.7))

// Resize (aspect fit)
let resized = image.resizeImage(512, opaque: false, contentMode: .scaleAspectFit)

