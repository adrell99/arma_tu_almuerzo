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
            // ===== BANNER GRANDE =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: Colors.orangeAccent,
              child: const Center(
                child: Text(
                  "MENÚ DEL DÍA",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ===== TARJETA CON LO QUE INCLUYE HOY =====
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
                      const SizedBox(height: 20),
                      _buildInclusionItem("🥣 Sopa", sopaDelDia),
                      const SizedBox(height: 15),
                      _buildInclusionItem("🍲 Principio", principioDelDia),
                      const SizedBox(height: 15),
                      _buildInclusionItem("🥗 Ensalada", ensaladaDelDia),
                      const SizedBox(height: 15),
                      _buildInclusionItem("🍽️ Contorno", contornoDelDia),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== LISTA DE PLATOS FIJOS (tu código original) =====
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
              shrinkWrap: true, // Importante para que funcione dentro de Column
              physics:
                  const NeverScrollableScrollPhysics(), // Evita scroll anidado
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

  // Método auxiliar para los ítems de inclusión
  Widget _buildInclusionItem(String icon, String texto) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
