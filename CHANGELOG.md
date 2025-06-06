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