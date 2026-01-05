// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'menu_fijo_screen.dart';
import 'arma_almuerzo_screen.dart';
import 'desayunos_screen.dart';
import 'carrito.dart';
//import 'chat_carino_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Estamos desarrollando la función\n"Arma Tu Desayuno" 🥐☕\n\n'
          '¡Muy pronto podrás personalizar tu desayuno como quieras!\n\n'
          'Gracias por tu paciencia, mi vida 😊',
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
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Entendido ❤️',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarChatEnMantenimiento(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.pink[50],
        title: const Row(
          children: [
            Icon(Icons.favorite_border, color: Colors.pinkAccent, size: 32),
            SizedBox(width: 12),
            Text(
              '¡Proximamente!',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Estamos trabajando duro para mejorar la IA ❤️\n\n'
          'Pronto volverá más lista, más dulce y con muchas más sorpresas para ti.\n\n'
          'Gracias por tu paciencia, te mando un abrazo enorme 🤗',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, height: 1.5),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '❤️',
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
            icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
            iconSize: 34,
            tooltip: 'Habla con Cariño ❤️',
            onPressed: () => _mostrarChatEnMantenimiento(context),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.orange),
            iconSize: 34,
            tooltip: 'Ver carrito',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarritoScreen()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Fondo con imagen
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
          // Gradiente oscuro
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(180),
                  Colors.black.withAlpha(100),
                  Colors.black.withAlpha(200),
                ],
              ),
            ),
          ),
          // Contenido principal
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
                          offset: Offset(4, 4),
                        ),
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
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // === TARJETA DESTACADA DE DESAYUNOS (más pequeña y elegante) ===
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.free_breakfast,
                            size: 32, color: Colors.brown[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '¡También tenemos desayunos! ☕🥐',
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'De 6:00 AM a 10:30 AM • Desliza abajo ↓',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_downward,
                            size: 28, color: Colors.brown[700]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // === MENÚ DEL DÍA ===
                  _buildBotonConTextoHorario(
                    context: context,
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

                  // === ARMA TU ALMUERZO ===
                  _buildBotonConTextoHorario(
                    context: context,
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
                    context: context,
                    icon: Icons.free_breakfast,
                    label: 'Desayunos',
                    color: Colors.amber[100]!,
                    textColor: Colors.black87,
                    horarioTexto: 'Disponible de 6:00 AM a 10:30 AM',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DesayunosScreen()),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // === ARMA TU DESAYUNO (en desarrollo) ===
                  _buildBotonConTextoHorario(
                    context: context,
                    icon: Icons.build_circle,
                    label: 'Arma Tu Desayuno',
                    color: Colors.amber[600]!,
                    textColor: Colors.white,
                    horarioTexto: 'Disponible de 6:00 AM a 10:30 AM',
                    onPressed: () => _mostrarEnDesarrollo(context),
                  ),

                  const SizedBox(height: 60),

                  // === INDICADOR DE SCROLL ===
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Desliza hacia abajo para ver más ↓',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 10,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonConTextoHorario({
    required BuildContext context,
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
          onPressed: onPressed,
        ),
        const SizedBox(height: 8),
        Text(
          horarioTexto,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withAlpha(230),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

