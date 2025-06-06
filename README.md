# PinCode

[](https://pub.dev/packages/pin_code)
[](https://opensource.org/licenses/MIT)

A flexible and highly customizable PIN code entry widget for Flutter, designed with a clean architecture and no third-party dependencies.

## Example of `PinCode` with different themes and error animation.
<img width="1363" alt="Screenshot" src="https://github.com/user-attachments/assets/ebf09d61-fbbb-48f8-8b85-51601f263217" />

![timer_code](https://github.com/user-attachments/assets/0013bc5c-e991-43c8-93c5-7fdc75046937)

![pin_login_system](https://github.com/user-attachments/assets/99d5396d-454f-4124-9229-7a2d4469806c)


## Features

- **Zero Dependencies**: Full control and stability with no third-party libraries.
- **Highly Customizable**: Extensive styling options via the `PinTheme` class to match your app's design.
- **Core Functionality**: Includes error animations, clipboard support (paste), keyboard management, and form validation.
- **Modern & Standard**: Built with modern Flutter practices, including null safety and a simple, predictable API.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pin_code: ^0.1.0
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

`PinCode` is a heavily refactored and simplified version of the original [pin\_code\_fields](https://github.com/adar2378/pin_code_fields) library.

The goal was to modernize the architecture, remove dependencies, and simplify the API for easier maintenance and use. Full credit and thanks go to the original author, [adar2378](https://github.com/adar2378), for their foundational work.

## Contributing

Contributions are welcome\! If you find a bug or want to suggest a new feature, please feel free to open an issue or submit a pull request.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin feature/my-new-feature`).
5.  Open a new Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.
