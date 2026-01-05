// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFE53935), // Fondo rojo por si la imagen no cubre todo
        ),
        child: Center(
          child: Image.asset(
            'assets/images/menu/splash_moto.png', // ← Tu imagen con la moto y textos
            fit: BoxFit
                .contain, // ← CLAVE: Muestra la imagen completa sin recortar
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
      // Loader opcional encima (si quieres que se vea "cargando")
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: const Padding(
      //   padding: EdgeInsets.only(bottom: 50),
      //   child: CircularProgressIndicator(color: Colors.white, strokeWidth: 6),
      // ),
    );
  }
}
