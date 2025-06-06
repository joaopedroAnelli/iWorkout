# Developer Guidelines

## Build Commands
Run the following commands to verify the application builds:

```bash
xcodebuild -project iWorkout.xcodeproj -scheme iWorkout CODE_SIGNING_ALLOWED=NO build
xcodebuild -project iWorkout.xcodeproj -scheme "iWorkout Watch App" CODE_SIGNING_ALLOWED=NO build
```

## Coding Conventions
- Use 4-space indentation.
- Variables and functions use `camelCase`.
- Types use `PascalCase`.
- Place opening braces on the same line as the declaration.
- Keep lines under 120 characters.

## Localization
Update the `Localizable.strings` files in `en.lproj` and `pt.lproj` whenever UI strings change.

## Commit Messages
Write commit summaries in the imperative mood and keep them under 72 characters.

## Tests
There are currently no automated tests. Run the build commands above to ensure the code compiles.
