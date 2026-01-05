### 1.2.0

#### Fixed
- **Theme InputDecoration Override**: Fixed an issue where the app's `inputDecorationTheme` was overriding the hidden `TextFormField` styles, causing it to become visible behind the PIN fields. Added explicit transparent decorations (`fillColor`, `focusColor`, `hoverColor`, `errorBorder`, `focusedErrorBorder`, `disabledBorder`) to prevent theme inheritance. (Thanks to [@Pavluke](https://github.com/Pavluke) for reporting and suggesting the fix in [PR #2](https://github.com/JhonaCodes/pin_code/pull/2))

#### Added
- **`inputDecoration` Parameter**: Exposed optional `InputDecoration` parameter in `PinCode` widget, allowing users to customize the hidden input field decoration if needed.

#### Changed
- **Architecture Refactor**: Improved code structure following Flutter coding standards:
  - **`PinFieldStyleCalculator`**: New class that separates style calculation logic from UI rendering.
  - **`PinFieldData` Record**: Dart 3 record type containing pre-calculated styles (fillColor, border) for each field.
  - **`_PinField` Widget**: Extracted individual PIN field rendering into a dedicated `StatelessWidget`.
  - **Functional Composition**: Replaced imperative `_generateFields()` loop with `.expand().toList()` pattern for cleaner widget generation.
- **Private Widgets**: Converted all internal builder methods to private `StatelessWidget` classes (`_HiddenTextFormField`, `_PinFieldsRow`, `_PinField`, `_PinFieldChild`).

### 1.1.0
- **Dart 3 Modernization**: Applied enum shorthand syntax across the entire project (`.center` instead of `Alignment.center`).
- **New `_PinFieldChild` Widget**: Extracted PIN field content logic into a dedicated private `StatelessWidget` for better separation of concerns.
- **Switch Expressions**: Replaced if-else chains with Dart 3 switch expressions and pattern matching for cleaner, more declarative code.
- **Code Simplification**: Reduced boilerplate with arrow functions and collection-if syntax.

### 1.0.2
-  **Update Readme**.

### 1.0.1
-  **Update description**.

### 1.0.0

This is the initial release of `pin_code`, a heavily refactored and simplified version of the original `pin_code_fields` library. The goal of this version is to provide a stable, maintainable, and dependency-free foundation.

#### Added

-   **New Simplified API**: Introduced a cleaner, more intuitive API for easier implementation.
-   **Clean Architecture**: Separated business logic from the UI by using a `PinCodeMixin`, improving code readability and maintainability.
-   **Modern `PinCodeTheme`**: Implemented a `PinCodeTheme` class with a standard `copyWith` method for easier and more predictable styling.
-   **Comprehensive Documentation**: Added complete English documentation for all public-facing classes, methods, and properties.
-   **Official Changelog, README, and License**: Created standard package files for community use.

#### Changed

-   **Project Renaming**: The library is now `pin_code`.
-   **Complete Refactor**: The entire codebase was refactored from the original `pin_code_fields` library to improve architecture and remove complexity.

#### Removed
-   **Non-Essential Features**: Removed complex features such as multiple animation types, granular haptic feedback levels, and the built-in paste dialog to create a more lightweight and focused widget.
-   **Helper Classes**: Removed the `DialogConfig` and `Gradiented` classes as part of the simplification process.

#### Fixed

-   **Clipboard Paste Crash**: Fixed a critical null-safety error that occurred when attempting to paste from an empty or non-text clipboard.