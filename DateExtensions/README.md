# DateExtensions

Swift extensions for `Date` that cover deterministic parsing/formatting, calendar math, relative strings, and epoch milliseconds without extra dependencies.

## What’s included
- `Date+ParsingFormatting.swift` — fixed-format and ISO 8601 parsing/formatting, localized display strings, relative time.
- `Date+CalendarMath.swift` — start/end of day/week/month helpers, component addition, and day-difference utilities.
- `Date+Epoch.swift` — `millisecondsSince1970` and `init(milliseconds:)` convenience.

## Highlights
- Deterministic formatting defaults to `en_US_POSIX` + UTC for API-safe dates.
- Localized variants use the provided locale/time zone for user-facing strings.
- Calendar math uses `Calendar`/`DateComponents` to avoid fragile time-interval math.

## Requirements
- Platforms: iOS 13+ (works on iPadOS/macOS/watchOS/tvOS as well).
- Swift: 5.7+

## Installation
- Manual: copy the Swift files in `DateExtensions/` into your target.
- Swift Package Manager: not yet published; manual copy recommended for now.

## Usage
```swift
import Foundation

// Deterministic fixed-format parsing/formatting
let apiDate = Date(string: "2024-03-10 15:42:00")
let stable = apiDate?.toString() // "2024-03-10 15:42:00" (UTC, en_US_POSIX)

// ISO 8601
let iso = Date(iso8601: "2024-03-10T15:42:00Z")?
    .toISO8601String(includeFractionalSeconds: true)

// Localized display + relative time
let pretty = Date.now.formatted(dateStyle: .long, timeStyle: .short, locale: .current, timeZone: .current)
let relative = Date.now.addingTimeInterval(-300).relativeDescription() // "5 min ago"

// Calendar math + epoch
let weekStart = Date.now.startOfWeek()
let inTwoDays = Date.now.adding(days: 2)
let diff = inTwoDays.days(since: Date.now) // 2
let ms = Date.now.millisecondsSince1970
let fromMs = Date(milliseconds: ms)
```

