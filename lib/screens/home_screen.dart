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
      appBar: AppBar(
        title: const Text('Arma Tu Almuerzo 🍽️'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarritoScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!\nElige cómo quieres pedir hoy',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                textStyle: const TextStyle(fontSize: 22),
                backgroundColor: Colors.orange[100],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuFijoScreen()),
                );
              },
              child: const Text('Menú del Día'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                textStyle: const TextStyle(fontSize: 22),
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ArmaAlmuerzoScreen()),
                );
              },
              child: const Text('Arma Tu Almuerzo'),
            ),
          ],
        ),
      ),
    );
  }
}
