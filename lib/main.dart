// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart'; // Tu pantalla principal
import 'providers/carrito_provider.dart'; // ← ESTE ES EL IMPORT QUE FALTABA

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarritoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arma Tu Almuerzo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      // Si usas navegación con nombres, puedes agregar rutas aquí:
      // routes: {
      //   '/carrito': (context) => const CarritoScreen(),
      // },
    );
  }
}

