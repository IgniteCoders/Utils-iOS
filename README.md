# Utils-iOS

Lightweight Swift utilities and UIKit extensions for common iOS needs: date handling, remote image loading with caching, simple view styling, and string sizing helpers.

## Requirements
- iOS 13+
- Swift 5.7+
- Xcode 14+

## Modules
- [`DateExtensions/`](DateExtensions) — deterministic date parsing/formatting (fixed-format + ISO 8601), calendar math (start/end of periods, add components), relative strings, epoch milliseconds.
- [`UIImageViewExtensions/`](UIImageViewExtensions) — async image loading into `UIImageView` with `NSCache`, placeholder support, cancellation for reusable cells, main-thread completion.
- [`UIViewExtensions/`](UIViewExtensions) — chainable styling helpers to round corners, make circles, set borders, and apply configurable shadows.
- [`StringExtensions/`](StringExtensions) — text sizing helper to compute bounding size given a font and width for manual layout or dynamic cells.
- [`UIViewControllerExtensions/`](UIViewControllerExtensions) — keyboard notification helpers with overridable show/hide hooks to adjust constraints (e.g., bottom constraints following the keyboard).

## Installation
- Manual: copy the Swift files from the module folders you need into your target.
- Swift Package Manager: not published yet; manual copy is recommended for now.

## How to use
- Pick the module(s) you need and review the module README for API details and examples.
- Add the `.swift` files to your Xcode target and import `UIKit`/`Foundation` as needed.

## License
MIT (see `LICENSE`).

