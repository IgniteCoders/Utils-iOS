//
//  UIImageViewExtensions.swift
//  Utils-iOS
//
//  Created by IgniteCoders on 10/03/24.
//
//  UIImageView convenience methods to load remote images safely.
//  Features:
//  - URLSession-based downloading with HTTP caching
//  - In-memory NSCache to avoid re-downloading images
//  - Optional placeholder shown immediately
//  - Optional completion handler on the main thread
//  - Cancellation of in-flight requests to avoid cell reuse issues
//  - Race-condition protection by tracking the latest requested URL
//

import UIKit

/// A tiny in-memory image cache backed by NSCache.
/// - Note: This cache is process-local and volatile (not persisted to disk).
///         It is safe to use from multiple threads.
private final class ImageCache {
    /// Shared singleton cache instance.
    static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {
        // Tune as needed based on your app’s memory profile.
        cache.countLimit = 1000
        cache.totalCostLimit = 100 * 1024 * 1024 // ~100 MB
    }

    /// Returns a cached image for the given URL if available.
    /// - Parameter url: The URL key.
    /// - Returns: The cached UIImage, or nil if not cached.
    func image(for url: NSURL) -> UIImage? {
        cache.object(forKey: url)
    }

    /// Inserts an image into the cache for the given URL.
    /// - Parameters:
    ///   - image: The image to cache.
    ///   - url: The URL key.
    func insert(_ image: UIImage, for url: NSURL) {
        // Use image memory size as cost when possible.
        let cost: Int
        if let cgImage = image.cgImage {
            cost = cgImage.bytesPerRow * cgImage.height
        } else {
            cost = 1
        }
        cache.setObject(image, forKey: url, cost: cost)
    }
}

/// Keys used for Objective‑C associated objects on UIImageView.
/// The stored numeric value is irrelevant; only the variable's unique address is used.
/// See objc_getAssociatedObject/objc_setAssociatedObject.
private enum AssociatedKeys {
    /// Key for the currently running URLSessionDataTask.
    static var taskKey: UInt8 = 0
    /// Key for the latest URL requested on this image view.
    static var urlKey: UInt8 = 0
}

extension UIImageView {

    /// The currently running URLSessionDataTask associated with this image view, if any.
    /// - Important: Stored via Objective‑C associated objects; do not access directly from outside.
    private var currentURLTask: URLSessionDataTask? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.taskKey) as? URLSessionDataTask }
        set { objc_setAssociatedObject(self, &AssociatedKeys.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// The most recent URL requested for this image view.
    /// Used to guard against race conditions when views are reused (e.g., in table/collection cells).
    private var currentURL: URL? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &AssociatedKeys.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    // MARK: - Public API

    /// Cancels any in-flight image request associated with this image view.
    ///
    /// - Discussion:
    ///   Call this from `prepareForReuse()` of a UITableViewCell/UICollectionViewCell
    ///   to prevent incorrect images appearing due to cell reuse.
    public func cancelImageLoad() {
        currentURLTask?.cancel()
        currentURLTask = nil
        currentURL = nil
    }

    /// Sets the image from a URL string.
    ///
    /// - Parameter urlString: The image URL as a string.
    ///
    /// - Note: If the string cannot be converted to a URL, this call is a no-op.
    /// - SeeAlso: `setImage(from:placeholder:)`, `setImage(from:placeholder:completion:)`
    public func setImage(from urlString: String) {
        setImage(from: urlString, placeholder: nil, completion: nil)
    }

    /// Sets the image from a URL string, optionally showing a placeholder immediately.
    ///
    /// - Parameters:
    ///   - urlString: The image URL as a string.
    ///   - placeholder: An optional placeholder image to display while loading.
    ///
    /// - Note: If the string cannot be converted to a URL, this call is a no-op.
    public func setImage(from urlString: String, placeholder: UIImage?) {
        setImage(from: urlString, placeholder: placeholder, completion: nil)
    }

    /// Sets the image from a URL string, with optional placeholder and completion.
    ///
    /// - Parameters:
    ///   - urlString: The image URL as a string.
    ///   - placeholder: An optional placeholder image to display while loading.
    ///   - completion: An optional completion called on the main thread with the result.
    ///
    /// - Important: UI updates are performed on the main thread. Networking happens off the main thread.
    /// - Note: If the string cannot be converted to a URL, this call is a no-op.
    public func setImage(from urlString: String, placeholder: UIImage?, completion: ((Result<UIImage, Error>) -> Void)?) {
        guard let url = URL(string: urlString) else { return }
        setImage(from: url, placeholder: placeholder, completion: completion)
    }

    /// Sets the image from a URL.
    ///
    /// - Parameter url: The image URL.
    ///
    /// - Discussion:
    ///   This method:
    ///   - Cancels any previous in-flight request for this image view.
    ///   - Sets a cached image immediately if available.
    ///   - Downloads with URLSession, validates the response, decodes a UIImage, caches it, and sets it on the main thread.
    public func setImage(from url: URL) {
        setImage(from: url, placeholder: nil, completion: nil)
    }

    /// Sets the image from a URL, optionally showing a placeholder immediately.
    ///
    /// - Parameters:
    ///   - url: The image URL.
    ///   - placeholder: An optional placeholder image to display while loading.
    public func setImage(from url: URL, placeholder: UIImage?) {
        setImage(from: url, placeholder: placeholder, completion: nil)
    }

    /// Sets the image from a URL, with optional placeholder and completion.
    ///
    /// - Parameters:
    ///   - url: The image URL.
    ///   - placeholder: An optional placeholder image to display while loading.
    ///   - completion: An optional completion called on the main thread with the result.
    ///
    /// - Threading:
    ///   - UI updates are dispatched to the main thread.
    ///   - Network work runs on a background thread via URLSession.
    ///
    /// - Caching:
    ///   - An in-memory NSCache is used. If the image is cached, it is applied immediately and the completion is called with `.success`.
    ///
    /// - Cancellation and reuse:
    ///   - Any existing request for this image view is cancelled before starting a new one.
    ///   - The latest requested URL is tracked to avoid race conditions when views are reused.
    public func setImage(from url: URL, placeholder: UIImage?, completion: ((Result<UIImage, Error>) -> Void)?) {
        // Cancel any previous task
        cancelImageLoad()

        // Set placeholder immediately if provided
        if let placeholder = placeholder {
            self.image = placeholder
        }

        currentURL = url

        // Return cached image if available
        let nsURL = url as NSURL
        if let cached = ImageCache.shared.image(for: nsURL) {
            self.image = cached
            completion?(.success(cached))
            return
        }

        // Build request
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 10

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.currentURLTask = nil }

            // Ensure this response still corresponds to the latest requested URL for this image view
            guard self.currentURL == url else { return }

            if let error = error as NSError? {
                // Ignore cancellations silently
                if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    return
                }
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
                return
            }

            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode),
                  let data = data,
                  let image = UIImage(data: data) else {
                let status = (response as? HTTPURLResponse)?.statusCode ?? -1
                let err = NSError(domain: "UIImageViewExtensions", code: status, userInfo: [NSLocalizedDescriptionKey: "Failed to load or decode image"])
                DispatchQueue.main.async {
                    completion?(.failure(err))
                }
                return
            }

            // Cache the image
            ImageCache.shared.insert(image, for: nsURL)

            DispatchQueue.main.async {
                // Double-check race condition once more on main queue
                guard self.currentURL == url else { return }
                self.image = image
                completion?(.success(image))
            }
        }

        currentURLTask = task
        task.resume()
    }
}
