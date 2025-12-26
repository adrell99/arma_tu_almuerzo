// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'menu_fijo_screen.dart';
import 'arma_almuerzo_screen.dart';
import 'carrito.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.orange),
            iconSize: 34,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarritoScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Fondo bandeja paisa
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bandeja_paisa.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay oscuro - CORREGIDO: usando withValues en lugar de withOpacity
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Contenido principal - con adaptación a pantallas grandes/pequeñas
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isSmallScreen = constraints.maxHeight < 700;

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: isSmallScreen
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            const Text(
                              'Arma Tu Almuerzo 🍽️',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    blurRadius: 12,
                                    color: Colors.black,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '¡Bienvenido!\nElige cómo quieres pedir hoy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 60),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 25),
                                textStyle: const TextStyle(fontSize: 24),
                                backgroundColor: Colors.orange[100],
                                foregroundColor: Colors.black87,
                                elevation: 10,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MenuFijoScreen()),
                                );
                              },
                              child: const Text('Menú del Día'),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 25),
                                textStyle: const TextStyle(fontSize: 24),
                                backgroundColor: Colors.orange[700],
                                foregroundColor: Colors.white,
                                elevation: 10,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ArmaAlmuerzoScreen()),
                                );
                              },
                              child: const Text('Arma Tu Almuerzo'),
                            ),
                            if (!isSmallScreen) const Spacer(),
                            if (!isSmallScreen) const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
