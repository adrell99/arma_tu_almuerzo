import 'package:arma_tu_almuerzo/models/carrito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:arma_tu_almuerzo/main.dart';

void main() {
  testWidgets('La app carga el menú y muestra el ícono del carrito',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<CarritoProvider>(
        // ← Aquí el cambio clave
        create: (_) => CarritoProvider(),
        child:
            const MyApp(), // ← ¡¡¡CAMBIA MyApp por el nombre EXACTO de tu clase principal!!!
      ),
    );

    await tester.pumpAndSettle();

    // Verifica título del menú
    expect(find.text('Menú del Día'), findsOneWidget);

    // Verifica ícono del carrito
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);

    // Prueba abrir el carrito
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    expect(find.text('Mi Carrito'), findsOneWidget);
    expect(find.text('El carrito está vacío'), findsOneWidget);
  });
}
