# UIViewExtensions

A lightweight set of `UIView` extensions for iOS that simplify common UI styling tasks such as rounding corners, making views circular, adding borders, and applying drop shadows.

These helpers are designed to be chainable and intuitive, letting you write cleaner UI code.


## Features

* Round corners with any radius
* Automatically make a view perfectly circular
* Add borders with configurable width and color
* Apply drop shadows with custom color, opacity, blur, and offset
* Chainable, expressive API
* Safe usage notes included (e.g., rounded corners + shadows)

## Installation

- Manual copy (recommended for small utilities)
  - Copy the files in UIViewExtensions into your project.
- Swift Package Manager
  - Not yet available.

## Usage

### Round all corners

```swift
myView.roundCorners(radius: 12)
```

### Make a perfectly circular view

```swift
avatarImageView.roundAsCircle()
```

### Add a border

```swift
myView.setBorder(width: 2, color: .systemBlue)
```

### Add a shadow

```swift
cardView.setShadow(
    color: UIColor.black,
    opacity: 0.25,
    radius: 6,
    offset: CGSize(width: 0, height: 3)
)
```

## Notes & Best Practices

### Rounded corners + shadow on the same view

iOS requires:

* Rounded corners → `masksToBounds = true`
* Shadow → `masksToBounds = false`

These conflict.
To get both rounded corners **and** a shadow, wrap your content view inside a container:

```swift
shadowContainer.addSubview(contentView)

contentView.roundCorners(radius: 12) // inner view
shadowContainer.roundCorners(radius: 12).setShadow() // outer view
```

## Extension Reference

### `roundCorners(radius:)`

Rounds all corners of the view.
Sets `masksToBounds = true`.

### `roundAsCircle()`

Makes the view circular using its smallest dimension.
Call after layout.

### `setBorder(width:color:)`

Adds a border to the view.

### `setShadow(color:opacity:radius:offset:)`

Applies a drop shadow.
Sets `masksToBounds = false`.

