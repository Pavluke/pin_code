// test/theme_and_layout_test.dart

import 'config/test_helpers.dart';

void main() {
  group('Golden Tests - Theme & Layout', () {
    testWidgets('renders with default (underline) shape', (tester) async {
      await pumpGoldenTest(
        tester,
        'theme_shape_underline',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 4,
            controller: TextEditingController(text: "12"),
            showCursor: false,
          ),
        ),
      );
    });

    testWidgets('renders with box shape', (tester) async {
      await pumpGoldenTest(
        tester,
        'theme_shape_box',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 5,
            controller: TextEditingController(text: "123"),
            showCursor: false,
            pinTheme: PinCodeTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      );
    });

    testWidgets('renders with circle shape', (tester) async {
      await pumpGoldenTest(
        tester,
        'theme_shape_circle',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 4,
            controller: TextEditingController(text: "123"),
            showCursor: false,
            pinTheme: PinCodeTheme(shape: PinCodeFieldShape.circle),
          ),
        ),
      );
    });

    testWidgets('renders with activeFill enabled', (tester) async {
      await pumpGoldenTest(
        tester,
        'theme_property_active_fill',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 5,
            enableActiveFill: true,
            controller: TextEditingController(text: "123"),
            showCursor: false,
            pinTheme: PinCodeTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              activeColor: Colors.blue.shade800,
              inactiveColor: Colors.grey.shade400,
              selectedFillColor: Colors.blue.shade100,
              activeFillColor: Colors.blue.shade100,
              inactiveFillColor: Colors.grey.shade200,
            ),
          ),
        ),
      );
    });

    testWidgets('renders with separatorBuilder', (tester) async {
      await pumpGoldenTest(
        tester,
        'layout_property_separator_builder',
        size: const Size(500, 150),
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 4,
            showCursor: false,
            controller: TextEditingController(text: "12"),
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('-', style: TextStyle(fontSize: 24)),
            ),
          ),
        ),
      );
    });

    testWidgets('renders with custom sizes and MainAxisAlignment', (
      tester,
    ) async {
      await pumpGoldenTest(
        tester,
        'layout_custom_sizes_and_alignment',
        widget: Builder(
          builder: (context) => PinCode(
            appContext: context,
            length: 4,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            controller: TextEditingController(text: "98"),
            showCursor: false,
            pinTheme: PinCodeTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(20),
              fieldHeight: 70,
              fieldWidth: 60,
            ),
          ),
        ),
      );
    });
  });
}
