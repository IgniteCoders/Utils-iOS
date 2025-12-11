# UIViewControllerExtensions

Keyboard handling helpers for `UIViewController` that simplify registering/unregistering for keyboard show/hide notifications and overriding callbacks to adjust layout (e.g., constraints following the keyboard).

## What’s included
- `UIViewController+Keyboard.swift` — convenience methods to register/unregister for keyboard notifications and overridable hooks `keyboardWillShow(_:)` / `keyboardWillHide(_:)`.

## Highlights
- Single-call registration and cleanup for keyboard notifications.
- Overridable hooks to keep keyboard-handling code tidy.
- Works well with bottom constraints that need to follow the keyboard while respecting safe areas.

## Requirements
- Platforms: iOS 13+.
- Swift: 5.7+

## Installation
- Manual: copy `UIViewController+Keyboard.swift` into your target.
- Swift Package Manager: not published yet; manual copy recommended for now.

## Usage
```swift
import UIKit

class MyViewController: UIViewController {
    @IBOutlet private var keyboardConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardConstraint.isActive = false
        registerForKeyboardNotifications()
    }

    override func keyboardWillShow(_ notification: Notification) {
        keyboardConstraint.isActive = true
    }

    override func keyboardWillHide(_ notification: Notification) {
        keyboardConstraint.isActive = false
    }

    deinit {
        unregisterForKeyboardNotifications()
    }
}
```

## Notes
- If you add observers in `viewWillAppear`, remove them in `viewWillDisappear` to limit notification scope.
- Extract animation duration/curve and final keyboard frame from `notification.userInfo` to animate constraint changes in sync with the keyboard.
