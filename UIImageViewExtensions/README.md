# UIImageViewExtensions

Lightweight, dependency-free convenience methods for safely loading remote images into `UIImageView`.

## Features

* **Remote image loading via `URLSession`**
  Uses system HTTP caching, redirects, and timeouts.
* **In-memory image caching (`NSCache`)**
  Prevents unnecessary repeated downloads.
* **Immediate placeholder support**
* **Completion handler** (always on the main thread)
* **Automatic cancellation** of in-flight requests
  Ideal for reusable table/collection-view cells.
* **Race-condition safe** via URL tracking
* **Zero external dependencies** — pure Swift + UIKit


## Included File

### `UIImageView+ImageLoading.swift`

Provides a small, robust API for asynchronously loading images into a `UIImageView` with caching and reuse protection.


## API

```swift
extension UIImageView {
    // MARK: - URL String Variants
    func setImage(from urlString: String)
    func setImage(from urlString: String, placeholder: UIImage?)
    func setImage(
        from urlString: String,
        placeholder: UIImage?,
        completion: ((Result<UIImage, Error>) -> Void)?
    )

    // MARK: - URL Variants
    func setImage(from url: URL)
    func setImage(from url: URL, placeholder: UIImage?)
    func setImage(
        from url: URL,
        placeholder: UIImage?,
        completion: ((Result<UIImage, Error>) -> Void)?
    )

    // MARK: - Cancellation
    func cancelImageLoad()
}
```


## Usage

### Load from a URL string

```swift
imageView.setImage(from: "https://example.com/image.jpg")
```

### Load with placeholder

```swift
imageView.setImage(
    from: url,
    placeholder: UIImage(named: "placeholder")
)
```

### Load with completion handler

```swift
imageView.setImage(from: url) { result in
    switch result {
    case .success(let image):
        print("Loaded image size:", image.size)
    case .failure(let error):
        print("Failed to load image:", error)
    }
}
```

### Use in reusable cells

```swift
override func prepareForReuse() {
    super.prepareForReuse()
    thumbnailImageView.cancelImageLoad()
    thumbnailImageView.image = nil // optional: clear old image
}

func configure(with item: Item) {
    thumbnailImageView.setImage(from: item.thumbnailURL)
}
```


## Notes & Behavior

* **Threading:**
  Networking occurs off the main thread; UI updates happen on the main thread.

* **Caching:**
  An in-memory `NSCache` stores decoded `UIImage` objects.
  Cached images are applied immediately.

* **Cancellation:**
  Starting a new request cancels the previous request for that image view.
  Calling `cancelImageLoad()` manually is recommended in reused cells.

* **Error Handling:**
  Completion returns `.failure` for network errors or invalid image data.

* **Customization:**

  * Adjust `NSCache` limits (`countLimit`, `totalCostLimit`).
  * Customize the `URLRequest` (cache policy, timeout) if needed.


## FAQ

### Does this support disk caching?

Yes, via `URLSession` + `URLCache` (system-managed HTTP disk caching).
This extension adds an **in-memory cache** for decoded `UIImage` objects.
For custom disk caching, configure your own `URLCache` at the app level.

### Is there an async/await version?

Not currently included, but the API can easily support an async variant for iOS 15+ without breaking existing calls.

