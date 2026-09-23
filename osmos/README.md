# Osmos Ads Demo – iOS Assignment

A native **SwiftUI** demo application that integrates the Osmos iOS SDK to fetch, render, and track display banner advertisements.

## Assignment

This project was created for the Osmos iOS Developer Assignment.

The application demonstrates:

- Native iOS / SwiftUI implementation
- Osmos SDK initialization
- AU-based display ad fetching
- Manual banner image rendering
- Aspect-ratio-preserving banner layout
- Multiple ads in a scrollable feed
- 50% visibility-based impression tracking
- One impression per ad
- Click tracking
- Landing-page navigation
- Loading, empty, and error states
- Retry support
- Duplicate-request prevention
- Lifecycle-aware visibility checking
- Basic analytics/event logging

## Osmos Configuration

The assignment-provided configuration is:

```text
clientId        = 10088010
productAdsHost  = demo.o-s.io
displayAdsHost  = demo-ba.o-s.io
```

The display ad request uses:

```text
cliUbid = Any
pageType = demo_page
adUnit = banner_ads
```

## SDK

The project uses the official Osmos iOS SDK through Swift Package Manager.

Official SDK repository:

https://github.com/onlinesales-ai/osmos-ios-sdk-spm.git

Official documentation:

- SDK Initialization: https://dev-hub.osmos.ai/docs/init-the-ios-sdk
- Ad Fetching: https://dev-hub.osmos.ai/docs/ad-fetching-ios
- Event Tracking: https://dev-hub.osmos.ai/docs/register-events-ios

## Architecture

```text
OsmosAdsDemoApp
        |
        v
   ContentView
        |
        v
   AdViewModel
        |
        v
  OsmosManager
        |
        v
    Osmos SDK
```

The UI layer is separated from the SDK integration so the ad-fetching and tracking logic remains reusable and testable.

### Main components

| File | Responsibility |
|---|---|
| `OsmosAdsDemoApp.swift` | Application entry point and SDK initialization |
| `OsmosManager.swift` | Osmos SDK integration and ad/event operations |
| `AdViewModel.swift` | UI state, loading, retry and request coordination |
| `BannerAd.swift` | Banner ad model |
| `BannerAdView.swift` | Banner rendering and click handling |
| `VisibilityTracker.swift` | 50% visibility detection |
| `AnalyticsLogger.swift` | Lightweight event logging |
| `ContentView.swift` | Main SwiftUI screen |
| `LoadingView.swift` | Loading UI |
| `AdErrorView.swift` | Error / fallback UI |

## Ad Fetching

The application requests display ads using the Ad Unit API.

The request parameters are:

```swift
cliUbid: "Any"
pageType: "demo_page"
adUnits: ["banner_ads"]
```

The response is mapped to the application's `BannerAd` model.

The assignment requires these fields:

```text
ads.banner_ads[0]

elements.value
elements.destination_url
impression_tracking_url
click_tracking_url
```

The image URL is used to render the banner and the destination URL is opened when the user taps the ad.

## Banner Rendering

Banner images are rendered manually using SwiftUI.

The banner maintains its original aspect ratio using the width and height supplied by the ad response.

Multiple ads can be displayed inside a scrollable SwiftUI view.

## Impression Tracking

The assignment requires an impression when at least **50% of the ad is visible**.

The reusable `VisibilityTracker` calculates the visible portion of each banner.

Conceptually:

```text
visible area / total ad area >= 0.50
```

When the threshold is reached, the Osmos impression event is fired.

Each ad is tracked only once during the current application session, preventing duplicate impression events when the user scrolls away and back.

## Click Tracking

When the user taps a banner:

1. The Osmos click event is registered.
2. The ad's `destination_url` is opened.

The SDK click APIs are used according to the available ad information.

## Error Handling

The application handles:

- SDK initialization problems
- Network/API failures
- Empty ad responses
- Invalid/missing ad fields
- Image loading failures
- Duplicate requests

The UI displays:

```text
Ad not available
```

when an ad cannot be rendered.

A retry action is available.

## Loading State

While an ad request is running:

- The Load Ad action is disabled.
- A loading indicator is displayed.
- Duplicate requests are prevented.

## Lifecycle Handling

Visibility is re-evaluated when the application becomes active again so that the impression logic remains lifecycle-aware.

## Logging

Important events are logged, including:

```text
Ad Loaded
Ad Failed
Impression Fired
Impression Failed
Click Fired
Click Failed
```

The project uses a lightweight logging layer so analytics/logging can be extended without changing the UI.

## How to Run

### Requirements

- macOS
- Xcode
- iOS 15 or later
- SwiftUI
- Internet connection for SDK/package resolution and ad/image requests

### Steps

1. Clone the repository.
2. Open:

```text
osmos/osmos.xcodeproj
```

3. Allow Xcode to resolve Swift Package dependencies.
4. Select an iOS Simulator or connected iPhone.
5. Build and Run.

## Demo Flow

For the assignment recording, demonstrate:

1. Application launch.
2. Ad loading.
3. Banner rendering.
4. Multiple ads in the scrollable feed.
5. Scrolling until an ad reaches at least 50% visibility.
6. `Impression Fired` logging.
7. Scrolling away and back to show no duplicate impression.
8. Tapping a banner.
9. Click event logging.
10. Destination URL opening.
11. Error / no-ad fallback.
12. Retry.

## Assumptions

- The Osmos SDK response contains the fields required by the assignment.
- `uclid` is available when the SDK impression/click event requires it.
- Banner dimensions are supplied by the ad response; fallback dimensions are used only when dimensions are unavailable.
- Impression tracking is session-scoped and therefore prevents duplicate events while the current app instance is running.

## Project Structure

```text
osmos/
├── osmos.xcodeproj/
├── osmos/
│   ├── Assets.xcassets/
│   ├── AdErrorView.swift
│   ├── AdViewModel.swift
│   ├── AnalyticsLogger.swift
│   ├── BannerAd.swift
│   ├── BannerAdView.swift
│   ├── ContentView.swift
│   ├── LoadingView.swift
│   ├── OsmosAdError.swift
│   ├── OsmosAdsDemoApp.swift
│   ├── OsmosManager.swift
│   └── VisibilityTracker.swift
└── README.md
```

## Submission

The assignment submission should contain:

- GitHub repository containing the working iOS project
- README with setup and architecture details
- Short demo recording showing:
  - Ad loading
  - Banner rendering
  - Impression tracking
  - Click handling
  - Error scenarios
