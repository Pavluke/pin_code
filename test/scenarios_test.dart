// test/scenarios_test.dart

import 'config/test_helpers.dart';

void main() {
  group('Golden Tests - UI Scenarios', () {
    testWidgets('renders in a dark mode login screen', (tester) async {
      final screen = Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, color: Colors.white, size: 48),
              const SizedBox(height: 24),
              const Text(
                'Enter Your Passcode',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 32),
              Builder(
                builder: (context) => PinCode(
                  appContext: context,
                  length: 4,
                  showCursor: false,
                  controller: TextEditingController(text: "12"),
                  pinTheme: PinCodeTheme(
                    shape: PinCodeFieldShape.box,
                    fieldHeight: 60,
                    fieldWidth: 60,
                    borderRadius: BorderRadius.circular(12),
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey.shade800,
                    selectedColor: Colors.lightBlueAccent,
                  ),
                  textStyle: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      );
      await pumpGoldenTest(
        tester,
        'scenario_dark_login',
        widget: screen,
        size: const Size(450, 800),
      );
    });

    testWidgets('renders in a light mode verification screen with visible cursor', (
      tester,
    ) async {
      // Para este test, no usamos la función de ayuda pumpGoldenTest
      // porque necesitamos control manual sobre los frames de la animación del cursor.

      // 1. SETUP
      await tester.binding.setSurfaceSize(const Size(450, 800));

      final screen = Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Email Verification'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Verify Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'We sent a 6-digit code to your@email.com',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              Builder(
                builder: (context) => PinCode(
                  appContext: context,
                  length: 6,
                  showCursor: true, // El cursor está activado intencionalmente
                  controller: TextEditingController(text: "123"),
                  enableActiveFill: true,
                  pinTheme: PinCodeTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    activeColor: Colors.black,
                    inactiveColor: Colors.grey.shade300,
                    selectedColor: Colors.blue,
                    activeFillColor: Colors.grey.shade100,
                    inactiveFillColor: Colors.grey.shade100,
                    selectedFillColor: Colors.blue.withAlpha(200),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // 2. EXECUTE
      await tester.pumpWidget(MaterialApp(home: screen));

      // LA SOLUCIÓN: En lugar de pumpAndSettle, avanzamos un solo frame.
      // Esto es suficiente para dibujar el estado inicial del widget y el cursor.
      await tester.pump();

      // 3. VERIFY
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/scenario_light_verification_with_cursor.png',
        ),
      );
    });

    testWidgets(
      'renders in a payment confirmation screen with alphanumeric code',
      (tester) async {
        final screen = Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 30,
                  child: Icon(Icons.check, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter Confirmation Code',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Check your banking app for the 5-character code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 30),
                Builder(
                  builder: (context) => PinCode(
                    appContext: context,
                    length: 5,
                    keyboardType: TextInputType.text, // Alfanumérico
                    controller: TextEditingController(text: "A4B"),
                    showCursor: false,
                    pinTheme: PinCodeTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey,
                      selectedColor: Colors.indigo,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        await pumpGoldenTest(
          tester,
          'scenario_payment_alphanumeric',
          widget: screen,
          size: const Size(450, 800),
        );
      },
    );
  });
}
