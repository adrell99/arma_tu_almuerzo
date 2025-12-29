// lib/screens/desayunos_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/menu_data.dart'; // ← Aquí está tu lista menuDesayunosFijos
import '../providers/carrito_provider.dart';
import 'carrito.dart';

class DesayunosScreen extends StatelessWidget {
  const DesayunosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desayunos ☕'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuDesayunosFijos.length,
        itemBuilder: (context, index) {
          final item = menuDesayunosFijos[index];

          return Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Imagen del desayuno
                Image.asset(
                  item.imagen,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.amber[100],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.free_breakfast,
                                size: 60, color: Colors.amber),
                            SizedBox(height: 8),
                            Text(
                              'Imagen no disponible',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Degradado oscuro para que el texto se lea bien
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),

                // Contenido: nombre, descripción, precio y botón
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item.nombre,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                blurRadius: 8,
                                color: Colors.black,
                                offset: Offset(2, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.descripcion,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.4,
                          shadows: [
                            Shadow(
                                blurRadius: 4,
                                color: Colors.black,
                                offset: Offset(1, 1)),
                          ],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${item.precio.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                              shadows: [
                                Shadow(
                                    blurRadius: 6,
                                    color: Colors.black,
                                    offset: Offset(2, 2)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final provider = Provider.of<CarritoProvider>(
                                  context,
                                  listen: false);

                              // Aquí usamos el método correcto de tu provider
                              // Si tienes uno específico para ítems fijos, cámbialo
                              // Por ahora uso el mismo que en almuerzos
                              provider.agregarItemNormal(item);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${item.nombre} agregado al carrito ☕'),
                                  backgroundColor: Colors.amber[700],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              'Agregar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
