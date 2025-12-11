# UIImageViewExtensions

Convenience methods for `UIImageView` that load remote images with caching, safe reuse, and main-thread completion—no external dependencies.

## What’s included
- `UIImageView+ImageLoading.swift` — async image loading from `URL`/`String`, in-memory caching via `NSCache`, placeholder support, cancellation, and main-thread completion callbacks.

## Highlights
- Uses `URLSession` + system `URLCache` for HTTP caching/redirects/timeouts.
- In-memory `NSCache` prevents repeated downloads of decoded images.
- Placeholder applied immediately while the request is in flight.
- Safe for reusable cells: starting a new request cancels the previous one.
- Completion handler always invoked on the main thread.

## Requirements
- Platforms: iOS 13+.
- Swift: 5.7+

## Installation
- Manual: copy `UIImageView+ImageLoading.swift` into your target.
- Swift Package Manager: not yet published; manual copy recommended for now.

## Usage
```swift
import UIKit

// Basic load
imageView.setImage(from: "https://example.com/image.jpg")

// With placeholder
imageView.setImage(
    from: URL(string: "https://example.com/image.jpg")!,
    placeholder: UIImage(named: "placeholder")
)

// With completion
imageView.setImage(from: url) { result in
    switch result {
    case .success(let image): print("Loaded:", image.size)
    case .failure(let error): print("Failed:", error)
    }
}

// In reusable cells
override func prepareForReuse() {
    super.prepareForReuse()
    thumbnailImageView.cancelImageLoad()
    thumbnailImageView.image = nil
}
```

## Notes
- Threading: networking off the main thread; image application on the main thread.
- Cancellation: starting a new load on the same view cancels the previous task.
- Caching: relies on `NSCache`; adjust limits or `URLRequest` configuration if needed.

