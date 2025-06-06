# iWorkout

iWorkout is a paired iOS and watchOS application built with SwiftUI. The iPhone app manages a list of exercises while the watch app mirrors this list and guides the user through each workout with short rest timers. State is synchronized between devices using **WatchConnectivity**.

## Features

* Maintain a list of exercises on the iPhone.
* Automatically sync the exercise list to the Apple Watch.
* Advance through exercises on the watch with a 30‑second rest timer between sets.

## Project Structure

```
/Shared               Shared module with business logic
/iWorkout             iOS target organized by feature
/iWorkout Watch App   watchOS target organized by feature
iWorkout.xcodeproj    Xcode project
```

### Shared

`SharedData.swift` implements a singleton object that conforms to `WCSessionDelegate` and `ObservableObject`. It keeps the exercise list in sync across devices via `updateApplicationContext`.

### iOS App

* `iWorkoutApp.swift` – entry point for the iPhone app. Initializes the shared data session.
* `ContentView.swift` – displays the exercise list with a button to add new exercises.
* `ExerciseListViewModel.swift` – stores the list and notifies the watch whenever it changes.
* `iWorkout.entitlements` – declares the application group used for sharing data.

### watchOS App

* `iWorkoutApp.swift` – main entry for the watch app.
* `ContentView.swift` – shows the synchronized exercise list and handles the rest timer between items.
* `iWorkout Watch App.entitlements` – uses the same application group as the iOS app.

## Building

Open `iWorkout.xcodeproj` in Xcode (version 14 or later recommended). Build and run the **iWorkout** target on an iPhone simulator or device, and the **iWorkout Watch App** target on a paired watch simulator or device. Both targets must have the same application group configured in order to communicate.

## Next Steps

The project currently lacks tests and documentation. Adding unit tests, improving error handling, and expanding the rest timer features would be valuable enhancements.

## Localization

The UI strings are defined using `LocalizedStringKey` so the app can be translated.
English is the base language and Brazilian Portuguese translations live under `*.lproj/Localizable.strings` in
each target's `Resources` folder. Add additional languages by creating a new
`<language>.lproj` directory with a `Localizable.strings` file containing the
desired translations.

