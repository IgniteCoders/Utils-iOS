# DateExtensions

A small, dependency-free collection of Swift extensions for Foundation.Date that make common date tasks safer and easier:

- Deterministic parsing/formatting (fixed-format and ISO 8601)
- User-facing localized formatting and relative time strings
- Calendar math helpers (start/end of day, week, month; add components; day differences)
- Epoch milliseconds helpers

These utilities are suitable for iOS, iPadOS, macOS, watchOS, and tvOS, and can be copied directly into your project.

## Contents

This folder includes:

- Date+ParsingFormatting.swift
  - Fixed-format parsing/formatting using DateFormatter with en_US_POSIX and UTC defaults
  - ISO 8601 (RFC 3339) parsing/formatting with optional fractional seconds
  - Localized user-facing formatting via dateStyle/timeStyle
  - Relative time strings via RelativeDateTimeFormatter
- Date+CalendarMath.swift
  - Start/end of day
  - Start of week
  - Start/end of month
  - Add calendar components (days/hours/minutes/seconds)
  - Difference in full calendar days
- Date+Epoch.swift
  - millisecondsSince1970 computed property
  - init(milliseconds:) convenience initializer

## Why these helpers?

- Determinism when you need it:
  - Fixed-format parsing/formatting defaults to en_US_POSIX and UTC to avoid locale and timezone surprises (per Apple’s QA1480 guidance).
- Localization when you want it:
  - User-facing formatting and relative strings respect the user’s locale/time zone when you pass `.current`.
- Safety and clarity:
  - Calendar math is implemented with Calendar and DateComponents, avoiding manual time interval math.

## Installation

Choose one:

- Manual copy (recommended for small utilities)
  - Copy the files in DateExtensions into your project.
- Swift Package Manager
  - Not yet available.

No third-party dependencies required.

## Quick Start

```swift
import Foundation

// Deterministic fixed-format parsing/formatting
if let date = Date(string: "2024-03-10 15:42:00") {
    let stable = date.toString() // "2024-03-10 15:42:00" (UTC, en_US_POSIX)
}

// ISO 8601 parsing/formatting
if let apiDate = Date(iso8601: "2024-03-10T15:42:00Z") {
    let iso = apiDate.toISO8601String(includeFractionalSeconds: true) // "2024-03-10T15:42:00.000Z"
}

// Localized user-facing formatting
let pretty = Date.now.formatted(dateStyle: .long, timeStyle: .short, locale: .current, timeZone: .current)

// Relative time
let relative = Date.now.addingTimeInterval(-300).relativeDescription() // "5 min ago" (locale-aware)

// Calendar math
let todayStart = Date.now.startOfDay()
let todayEnd = Date.now.endOfDay()
let weekStart = Date.now.startOfWeek()
let monthStart = Date.now.startOfMonth()
let monthEnd = Date.now.endOfMonth()

let inTwoDays = Date.now.adding(days: 2)
let diff = inTwoDays.days(since: Date.now) // 2

// Epoch milliseconds
let ms = Date.now.millisecondsSince1970
let fromMs = Date(milliseconds: ms)
