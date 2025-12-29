// lib/screens/menu_fijo_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/menu_data.dart';
import '../providers/carrito_provider.dart';
import 'carrito.dart';

class MenuFijoScreen extends StatelessWidget {
  const MenuFijoScreen({super.key});

  // ==== CAMBIA ESTOS TEXTOS E IMÁGENES CADA DÍA ====
  final String sopaDelDia = "Sopa de verduras con fideos y pollo";
  final String sopaImagen =
      "assets/images/sopa.jpg"; // Cambia por la ruta real de la imagen

  final String principioDelDia = "Lentejas guisadas";
  final String principioImagen =
      "assets/images/principio.jpg"; // Cambia por la ruta real

  final String ensaladaDelDia =
      "Ensalada mixta (lechuga, tomate, cebolla y zanahoria)";
  final String ensaladaImagen =
      "assets/images/ensalada.jpg"; // Cambia por la ruta real

  final String contornoDelDia = "Papa salada / Patacón / Yuca al vapor";
  final String contornoImagen =
      "assets/images/contorno.jpg"; // Cambia por la ruta real
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
                        imagen: sopaImagen,
                      ),
                      const SizedBox(height: 20),
                      _buildInclusionItemImproved(
                        emoji: "🍲",
                        titulo: "Principio",
                        descripcion: principioDelDia,
                        imagen: principioImagen,
                      ),
                      const SizedBox(height: 20),
                      _buildInclusionItemImproved(
                        emoji: "🥗",
                        titulo: "Ensalada",
                        descripcion: ensaladaDelDia,
                        imagen: ensaladaImagen,
                      ),
                      const SizedBox(height: 20),
                      _buildInclusionItemImproved(
                        emoji: "🍽️",
                        titulo: "Contorno",
                        descripcion: contornoDelDia,
                        imagen: contornoImagen,
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
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // Imagen del ítem
                      Image.asset(
                        item.imagen,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 180,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported,
                                      size: 50, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    'Imagen no disponible',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Degradado oscuro
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),

                      // Contenido: textos y botón
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              item.nombre,
                              style: const TextStyle(
                                fontSize: 22,
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
                                fontSize: 15,
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
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${item.precio.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
                                    final provider =
                                        Provider.of<CarritoProvider>(context,
                                            listen: false);
                                    provider.agregarItemNormal(item);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${item.nombre} agregado al carrito 🍱'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Agregar',
                                    style: TextStyle(color: Colors.white),
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
    required String imagen,
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
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagen,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported,
                      size: 40, color: Colors.grey),
                ),
              );
            },
          ),
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
