// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart'; // Tu pantalla principal

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Espera 3 segundos y luego va a HomeScreen
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.orange[700], // Color de fondo (cámbialo al de tu marca)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tu logo grande
            Image.asset(
              'assets/images/menu/logo.jpg',
              width: 200, // Ajusta el tamaño según tu logo
              height: 200,
            ),
            const SizedBox(height: 40),
            // Nombre del restaurante debajo (opcional)
            const Text(
              'Come casero tu cuerpo te lo agradecera',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            // Animación de carga (opcional pero queda pro)
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
