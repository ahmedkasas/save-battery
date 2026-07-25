# Save Battery (حفظ البطارية)

An iOS app (SwiftUI, iOS 16+) that helps you monitor your iPhone's battery and adopt habits that slow down long-term battery aging. Bilingual: Arabic and English.

Apple does not allow third-party apps to control system power settings or other apps' background activity, so this app focuses on what's actually possible on iOS:

- **Dashboard** — live battery percentage, charging state, and Low Power Mode status, with quick-access tips and a shortcut to the system Battery settings screen.
- **History** — a local log of charging sessions (start/end time, duration, and charge gained), tracked automatically in the background while the app is open.
- **Tips** — general battery-health guidance (avoiding extreme temperatures, reducing brightness, Optimized Battery Charging, etc.).
- **Settings** — an optional local notification when charging crosses a configurable percentage (default 80%), as a reminder to unplug.

## Project structure

```
SaveBattery.xcodeproj/       Xcode project file
SaveBattery/
  SaveBatteryApp.swift       App entry point
  Models/                    BatteryStatus, ChargeSession
  Services/                  BatteryMonitorService, ChargeHistoryStore, NotificationService
  ViewModels/                DashboardViewModel, HistoryViewModel, SettingsViewModel
  Views/                     RootTabView, DashboardView, HistoryView, TipsView, SettingsView
  Resources/                 en.lproj / ar.lproj Localizable.strings
  Assets.xcassets/           App icon and accent color placeholders
```

Architecture is a simple MVVM: `BatteryMonitorService` wraps `UIDevice` battery APIs and `ProcessInfo` Low Power Mode state behind a `@Published` property; `ChargeHistoryStore` observes it to record charge sessions to `UserDefaults`; `NotificationService` observes it to fire the charge-limit reminder. View models expose these to SwiftUI views.

## Requirements

- Xcode 15 or later (this project was authored without access to Xcode/a Mac, so open it in Xcode once to confirm it builds, and let Xcode manage code signing under **Signing & Capabilities** with your own Apple ID/team).
- iOS 16.0+ deployment target.

## Running

Open `SaveBattery.xcodeproj` in Xcode and run on a simulator or a real device (a physical device is needed to see real battery data — the simulator reports a fixed placeholder battery level).

## Notes / follow-ups

- No test target is scaffolded yet; add one via **File > New > Target > Unit Testing Bundle** if needed.
- The app icon and accent color asset slots are placeholders (no image supplied yet) — add real artwork in `Assets.xcassets` before submitting to the App Store.
- `PRODUCT_BUNDLE_IDENTIFIER` is set to `com.ahmedkasas.savebattery`; change it in the target's Build Settings if you want a different bundle ID.
