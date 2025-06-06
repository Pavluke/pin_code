import 'package:flutter/material.dart';
import 'package:pin_code/pin_code.dart';

/// An example of a clean and classic phone verification screen.
/// Demonstrates the use of a theme with the `underline` form.
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter Verification Code',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'A 6-digit code was sent to\n+1 234 567 8900',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 40),
            Builder(
              builder: (context) => PinCode(
                appContext: context,
                length: 6,
                onCompleted: (value) {
                  print("✅ Completed: $value");
                  // Aquí iría la lógica para verificar el código
                },
                pinTheme: PinCodeTheme(
                  // Estilo clásico de subrayado
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  // Colores para los diferentes estados
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: Colors.blue,
                ),
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't receive the code?", style: TextStyle(color: Colors.grey.shade600)),
                TextButton(
                  onPressed: () {
                    print("Resend code tapped");
                  },
                  child: const Text('Resend', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}