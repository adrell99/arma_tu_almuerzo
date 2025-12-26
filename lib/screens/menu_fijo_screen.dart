// lib/screens/menu_fijo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/menu_data.dart';
import '../providers/carrito_provider.dart';
import 'carrito.dart';

class MenuFijoScreen extends StatelessWidget {
  const MenuFijoScreen({super.key});

  // ==== CAMBIA ESTOS TEXTOS CADA DÍA ====
  final String sopaDelDia = "Sopa de verduras con fideos y pollo";
  final String principioDelDia = "Lentejas guisadas";
  final String ensaladaDelDia =
      "Ensalada mixta (lechuga, tomate, cebolla y zanahoria)";
  final String contornoDelDia = "Papa salada / Patacón / Yuca al vapor";
  // =======================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú del Día'),
        backgroundColor: Colors.orange,
        centerTitle: false,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== QUITAMOS EL BANNER GRANDE NARANJA (ya no está duplicado) =====

            const SizedBox(
                height: 16), // Espacio pequeño para que no pegue al AppBar

            // ===== TARJETA "HOY INCLUYE" SUBIDA MÁS ARRIBA =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hoy incluye:",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildInclusionItemImproved(
                        emoji: "🥣",
                        titulo: "Sopa",
                        descripcion: sopaDelDia,
                      ),
                      const SizedBox(height: 20),
                      _buildInclusionItemImproved(
                        emoji: "🍲",
                        titulo: "Principio",
                        descripcion: principioDelDia,
                      ),
                      const SizedBox(height: 20),
                      _buildInclusionItemImproved(
                        emoji: "🥗",
                        titulo: "Ensalada",
                        descripcion: ensaladaDelDia,
                      ),
                      const SizedBox(height: 20),
                      _buildInclusionItemImproved(
                        emoji: "🍽️",
                        titulo: "Contorno",
                        descripcion: contornoDelDia,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== ELIGE TU PLATO PRINCIPAL =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Elige tu plato principal",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),

            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: menuFijo.length,
              itemBuilder: (context, index) {
                final item = menuFijo[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      item.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.descripcion),
                    trailing: Text(
                      '\$${item.precio.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      final provider =
                          Provider.of<CarritoProvider>(context, listen: false);
                      provider.agregarItemNormal(item);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${item.nombre} agregado al carrito 🍱'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInclusionItemImproved({
    required String emoji,
    required String titulo,
    required String descripcion,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            descripcion,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 79, 65, 65),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
