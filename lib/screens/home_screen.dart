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
        title: const Text(
          'Arma Tu Almuerzo 🍽️',
          style: TextStyle(
            color: Colors.white, // Blanco
            fontSize: 32, // MÁS GRANDE (antes era ~20-24)
            fontWeight: FontWeight.bold, // Negrita para que resalte
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Colors.orange[700], // Carrito en naranja intenso
            iconSize: 34, // Un poco más grande para que se vea bien
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarritoScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo full screen (tu Bandeja Paisa)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/bandeja_paisa.jpg'), // ← nombre de tu foto
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay oscuro
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
          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¡Bienvenido!\nElige cómo quieres pedir hoy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
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
                  const SizedBox(height: 80),
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
                            builder: (_) => const ArmaAlmuerzoScreen()),
                      );
                    },
                    child: const Text('Arma Tu Almuerzo'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
