# PinCode

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![pin_code](https://img.shields.io/pub/v/pin_code.svg)](https://pub.dev/packages/pin_code)
[![Dart 3](https://img.shields.io/badge/Dart-3%2B-blue.svg)](https://dart.dev/)
[![Flutter 3.32](https://img.shields.io/badge/Flutter-3%2B-blue.svg)](https://flutter.dev/)

A flexible and fully customizable widget for PIN, OTP, and passcode entry. Perfect for verification screens, 2FA, transaction confirmations, and more.

## Example of `PinCode` with different themes and error animation.
<p align="center">
  <img src="https://github.com/user-attachments/assets/0013bc5c-e991-43c8-93c5-7fdc75046937" height="320" width="500" />
  <img src="https://github.com/user-attachments/assets/99d5396d-454f-4124-9229-7a2d4469806c" height="320" width="250"/>
</p>

<p align="center">
  <img width="740" alt="Screenshot" src="https://github.com/user-attachments/assets/348fd59f-0026-4476-99a8-0039d24477c2"/>
</p>


<p align="center">
  <img src="https://github.com/user-attachments/assets/e93b12dc-759f-453a-9a79-76e47c3b4d27" height="400" width="370"/>
  <img src="https://github.com/user-attachments/assets/8fd04bf0-73d9-4020-a098-3ce9fb9f6d60" height="400" width="370"/>
</p>

## Features

- **Zero Dependencies**: Full control and stability with no third-party libraries.
- **Highly Customizable**: Extensive styling options via the `PinTheme` class to match your app's design.
- **Core Functionality**: Includes error animations, clipboard support (paste), keyboard management, and form validation.
- **Modern & Standard**: Built with modern Flutter practices, including null safety and a simple, predictable API.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pin_code: ^1.0.2
```

Then, run `flutter pub get` and import it in your Dart code:

```dart
import 'package:pin_code/pin_code.dart';
```

## Basic Usage

Here is a simple example of how to use `PinCode`:

```dart
import 'package:flutter/material.dart';
import 'package:pin_code/pin_code.dart';

class BasicExample extends StatelessWidget {
  const BasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PinCode Basic Usage'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PinCode(
            appContext: context,
            length: 4,
            onChanged: (value) {
              print(value);
            },
            onCompleted: (value) {
              print("Completed: $value");
              // Show a dialog or navigate to the next screen
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Success"),
                  content: Text("PIN Verified: $value"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
```

## Customization

You can extensively customize the appearance of the fields using the `pinTheme` property. Create a `PinTheme` object and modify its properties. It's recommended to use the `copyWith` method on a default theme.

Here's an example of a customized "box" style field:

```dart
PinCode(
  appContext: context,
  length: 6,
  keyboardType: TextInputType.number,
  // obscureText: true, // Use this for password-like fields
  // obscuringCharacter: '●',
  pinTheme: PinTheme(
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(8),
    fieldHeight: 50,
    fieldWidth: 45,
    // Colors for different states
    activeColor: Colors.deepPurple,
    activeFillColor: Colors.white,
    selectedColor: Colors.deepPurple,
    selectedFillColor: Colors.deepPurple.withOpacity(0.1),
    inactiveColor: Colors.grey,
    inactiveFillColor: Colors.white,
    disabledColor: Colors.grey.shade200,
    errorBorderColor: Colors.redAccent,
  ),
  enableActiveFill: true, // Set to true to use the fill colors
  onCompleted: (value) {
    print("Completed: $value");
  },
)
```

## Main Properties

| Property                 | Type                           | Description                                                              |
| ------------------------ | ------------------------------ | ------------------------------------------------------------------------ |
| `length`                 | `int`                          | **Required.** The number of PIN fields to display.                       |
| `appContext`             | `BuildContext`                 | **Required.** The build context of the screen.                           |
| `controller`             | `TextEditingController?`       | Controls the text being edited.                                          |
| `onCompleted`            | `ValueChanged<String>?`        | Callback function when all fields are filled.                            |
| `onChanged`              | `ValueChanged<String>?`        | Callback function every time the input changes.                          |
| `pinTheme`               | `PinTheme`                     | The visual theme for the PIN fields.                                     |
| `obscureText`            | `bool`                         | Hides the input with a character. Defaults to `false`.                   |
| `keyboardType`           | `TextInputType`                | The type of keyboard to use for editing the text.                        |
| `enabled`                | `bool`                         | Whether the field is enabled for interaction. Defaults to `true`.        |
| `validator`              | `FormFieldValidator<String>?`  | An optional method that validates an input.                              |
| `errorAnimationController`| `StreamController?`           | A stream to trigger error animations externally.                         |

## Acknowledgments

`PinCode` is a modernized and simplified version of the [pin\_code\_fields](https://github.com/adar2378/pin_code_fields) library.

## Contributing

Contributions are welcome\! If you find a bug or want to suggest a new feature, please feel free to open an issue or submit a pull request.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin feature/my-new-feature`).
5.  Open a new Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.
