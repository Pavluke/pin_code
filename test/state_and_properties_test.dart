// test/state_and_properties_test.dart

import 'config/test_helpers.dart';

void main() {
  group('Golden Tests - States & Properties', () {
    testWidgets('renders correctly when disabled', (tester) async {
      await pumpGoldenTest(
        tester,
        'state_disabled',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 4,
            enabled: false,
            controller: TextEditingController(text: "12"),
            showCursor: false,
          ),
        ),
      );
    });

    testWidgets('renders correctly in readOnly state', (tester) async {
      await pumpGoldenTest(
        tester,
        'state_read_only',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 4,
            readOnly: true,
            controller: TextEditingController(text: "DONE"),
            showCursor: false,
            pinTheme: PinCodeTheme(
              activeColor: Colors.green,
              inactiveColor: Colors.green,
            ),
          ),
        ),
      );
    });

    testWidgets('renders correctly when completed', (tester) async {
      await pumpGoldenTest(
        tester,
        'state_completed',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 4,
            controller: TextEditingController(text: "4321"),
            showCursor: false,
          ),
        ),
      );
    });

    testWidgets('renders correctly with obscureText character', (tester) async {
      await pumpGoldenTest(
        tester,
        'property_obscure_character',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 6,
            obscureText: true,
            obscuringCharacter: '✶',
            controller: TextEditingController(text: "1234"),
            showCursor: false,
          ),
        ),
      );
    });

    testWidgets('renders correctly with obscuringWidget', (tester) async {
      await pumpGoldenTest(
        tester,
        'property_obscuring_widget',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 4,
            obscureText: true,
            obscuringWidget: const Icon(Icons.privacy_tip_rounded, size: 20),
            controller: TextEditingController(text: "123"),
            showCursor: false,
          ),
        ),
      );
    });

    testWidgets('renders correctly with hintCharacter', (tester) async {
      await pumpGoldenTest(
        tester,
        'property_hint_character',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 5,
            hintCharacter: '?',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 24),
            controller: TextEditingController(text: "12"),
            showCursor: false,
          ),
        ),
      );
    });

    testWidgets('renders error state from a Form validator', (tester) async {
      final formKey = GlobalKey<FormState>();
      await pumpGoldenTest(
        tester,
        'state_error_from_validator',
        widget: Form(
          key: formKey,
          child: Builder(
            builder: (context) => PinCode(
              appContext: context,
              length: 4,
              showCursor: false,
              pinTheme: PinCodeTheme(errorBorderColor: Colors.red.shade700),
              validator: (v) {
                return v!.length < 3 ? "Error" : null;
              },
            ),
          ),
        ),
      );

      // Disparamos la validación para activar el estado de error.
      formKey.currentState!.validate();
      await tester.pump(); // Re-dibujamos para aplicar el estilo de error.

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/state_error_from_validator_after_validate.png',
        ),
      );
    });
  });
}
