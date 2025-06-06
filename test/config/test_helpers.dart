// test/config/test_helpers.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Exportamos los paquetes comunes para no tener que importarlos en cada archivo de test.
export 'package:flutter/material.dart';
export 'package:flutter_test/flutter_test.dart';
export 'package:pin_code/pin_code.dart';

/// Una función de ayuda que envuelve un widget [PinCode] en un entorno de prueba
/// y lo compara con un archivo golden.
///
/// [tester]: El WidgetTester proporcionado por el test.
/// [goldenFileName]: El nombre del archivo .png que se generará (sin la extensión).
/// [widget]: El widget `PinCode` (o cualquier widget que lo contenga) a probar.
/// [size]: El tamaño de la pantalla virtual para el test.
/// [backgroundColor]: El color de fondo del Scaffold para el test.
Future<void> pumpGoldenTest(
  WidgetTester tester,
  String goldenFileName, {
  required Widget widget,
  Size size = const Size(450, 200),
  Color backgroundColor = const Color(0xFFF0F0F0),
}) async {
  // Establecemos un tamaño de pantalla consistente.
  await tester.binding.setSurfaceSize(size);

  // Envolvemos el widget en la estructura necesaria.
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child: widget),
      ),
    ),
  );

  // Esperamos a que la UI se estabilice.
  await tester.pumpAndSettle();

  // Comparamos el resultado con el archivo golden.
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$goldenFileName.png'),
  );
}
