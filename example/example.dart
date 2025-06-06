import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pin_code/pin_code.dart';

/// An example of a clean and classic phone passcode screen.
class PasscodeScreen extends StatelessWidget {
  const PasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: Colors.white,
              size: 50,
            ),
            const SizedBox(height: 24),
            const Text(
              'Enter Your Passcode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            Builder(
              builder: (context) => PinCode(
                appContext: context,
                length: 4,
                obscureText: true, // Oculta los dígitos
                obscuringCharacter: '●',
                enableActiveFill: true, // Habilita el color de fondo
                onCompleted: (value) {
                  log("🔑 Passcode entered: $value");
                },
                pinTheme: PinCodeTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  // Colores que funcionan bien en modo oscuro
                  activeColor: Colors.grey.shade700,
                  inactiveColor: Colors.grey.shade800,
                  selectedColor: Colors.lightBlueAccent,
                  activeFillColor: Colors.grey.shade800,
                  inactiveFillColor: Colors.grey.shade800,
                  selectedFillColor: Colors.grey.shade700,
                ),
                textStyle: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {
                log("Forgot passcode tapped");
              },
              child: const Text(
                'Forgot Passcode?',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
