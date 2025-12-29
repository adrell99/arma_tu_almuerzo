// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'menu_fijo_screen.dart';
import 'arma_almuerzo_screen.dart';
import 'desayunos_screen.dart';
//import 'arma_desayuno_screen.dart';
import 'carrito.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Mensaje "en desarrollo" para Arma Tu Desayuno
  void _mostrarEnDesarrollo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.amber[50],
        title: const Row(
          children: [
            Icon(Icons.construction, color: Colors.amber, size: 32),
            SizedBox(width: 12),
            Text(
              '¡Próximamente!',
              style: TextStyle(
                  color: Colors.amberAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Estamos desarrollando la función\n"Arma Tu Desayuno" 🥐\n\n¡Muy pronto podrás personalizar tu desayuno como quieras!\n\nGracias por tu paciencia 😊',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, height: 1.5),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'Entendido',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/menu/bandeja_paisa.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),

                  const Text(
                    '¡Elige Tu Comida! 🍽️',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                            blurRadius: 15,
                            color: Colors.black87,
                            offset: Offset(4, 4)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    '¡Bienvenido!\nSelecciona lo que deseas hoy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            blurRadius: 12,
                            color: Colors.black87,
                            offset: Offset(3, 3)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // === ALMUERZOS ===
                  _buildBotonConTextoHorario(
                    icon: Icons.restaurant_menu,
                    label: 'Menú del Día',
                    color: Colors.orange[100]!,
                    textColor: Colors.black87,
                    horarioTexto: 'Disponible de 11:00 AM a 3:00 PM',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MenuFijoScreen()),
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildBotonConTextoHorario(
                    icon: Icons.lunch_dining,
                    label: 'Arma Tu Almuerzo',
                    color: Colors.orange[700]!,
                    textColor: Colors.white,
                    horarioTexto: 'Disponible de 11:00 AM a 3:00 PM',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ArmaAlmuerzoScreen()),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // === DESAYUNOS ===
                  _buildBotonConTextoHorario(
                    icon: Icons.free_breakfast,
                    label: 'Desayunos',
                    color: Colors.amber[100]!,
                    textColor: Colors.black87,
                    horarioTexto: 'Disponible de 6:00 AM a 10:30 AM',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DesayunosScreen()),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // === ARMA TU DESAYUNO - EN DESARROLLO ===
                  _buildBotonConTextoHorario(
                    icon: Icons.build_circle,
                    label: 'Arma Tu Desayuno',
                    color: Colors.amber[600]!,
                    textColor: Colors.white,
                    horarioTexto: 'Disponible de 6:00 AM a 10:30 AM',
                    onPressed: () => _mostrarEnDesarrollo(context),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Botón normal con solo texto de horario debajo
  Widget _buildBotonConTextoHorario({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required String horarioTexto,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(icon, size: 28),
          label: Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 22),
            backgroundColor: color,
            foregroundColor: textColor,
            elevation: 12,
            shadowColor: Colors.black45,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: onPressed, // Siempre habilitado
        ),
        const SizedBox(height: 8),
        Text(
          horarioTexto,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

}
