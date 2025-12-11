//
//  UIViewController+Keyboard.swift
//  Utils-iOS
//
//  Created by IgniteCoders on 02/12/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Unregisters the view controller from keyboard show/hide notifications.
    ///
    /// Call this when the view controller is no longer interested in keyboard updates,
    /// such as in `viewWillDisappear(_:)` or `deinit` if you registered manually.
    ///
    /// Notes:
    /// - On iOS 9.0 and later, observers added with `addObserver(_:selector:name:object:)`
    ///   do not strictly require manual removal. However, explicitly removing observers
    ///   can help avoid delivering notifications to views that are no longer on-screen
    ///   and makes intent clear.
    /// - This method removes observers only for `keyboardWillShow` and `keyboardWillHide`.
    public func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Registers the view controller to receive keyboard show/hide notifications.
    ///
    /// After calling this method, the system will invoke `keyboardWillShow(_:)`
    /// and `keyboardWillHide(_:)` on this view controller when the keyboard is about
    /// to appear or disappear. Override those methods (or provide implementations in
    /// another extension) to adjust your layout, content insets, or constraints.
    ///
    /// Typical usage:
    /// - Call in `viewWillAppear(_:)` to begin observing.
    /// - Pair with `unregisterForKeyboardNotifications()` in `viewWillDisappear(_:)`.
    public func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// Called when the keyboard is about to be shown.
    ///
    /// Override this method to respond to the keyboard’s presentation. You can extract
    /// animation details and the keyboard’s frame from `notification.userInfo` using
    /// keys such as:
    /// - `UIResponder.keyboardAnimationDurationUserInfoKey`
    /// - `UIResponder.keyboardAnimationCurveUserInfoKey`
    /// - `UIResponder.keyboardFrameEndUserInfoKey`
    ///
    /// Use these values to animate your layout updates in sync with the keyboard.
    /// - Parameter notification: The notification containing keyboard animation and frame info.
    @objc open func keyboardWillShow(_ notification: Notification) { }

    /// Called when the keyboard is about to be hidden.
    ///
    /// Override this method to revert any layout adjustments made in `keyboardWillShow(_:)`.
    /// Animation details are available via `notification.userInfo`:
    /// - `UIResponder.keyboardAnimationDurationUserInfoKey`
    /// - `UIResponder.keyboardAnimationCurveUserInfoKey`
    /// - `UIResponder.keyboardFrameEndUserInfoKey`
    ///
    /// - Parameter notification: The notification containing keyboard animation and frame info.
    @objc open func keyboardWillHide(_ notification: Notification) { }
}
