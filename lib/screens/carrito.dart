// lib/screens/carrito_screen.dart
import 'package:arma_tu_almuerzo/models/carrito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ← Import correcto del provider
// Para acceder a MenuItem si necesitas algo extra

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${carrito.cantidadTotal} ítems',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: carrito.items.isEmpty
          ? const Center(
              child: Text(
                'El carrito está vacío',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: carrito.items.length,
                    itemBuilder: (context, index) {
                      final itemCarrito = carrito.items[index];
                      final item = itemCarrito.item; // ← Ahora sí coincide

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            item.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${item.descripcion}\nCantidad: ${itemCarrito.cantidad}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          leading: const Icon(Icons.restaurant_menu, size: 40),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${(item.precio * itemCarrito.cantidad).toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () {
                                      Provider.of<CarritoProvider>(context,
                                              listen: false)
                                          .remover(item);
                                    },
                                  ),
                                  Text(
                                    '${itemCarrito.cantidad}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.green),
                                    onPressed: () {
                                      Provider.of<CarritoProvider>(context,
                                              listen: false)
                                          .agregar(item);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Total
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.orange[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total a pagar:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${carrito.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botón confirmar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.orange,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: carrito.items.isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('¡Pedido confirmado!'),
                                  content: const Text(
                                      'Tu almuerzo llegará pronto. ¡Gracias por tu pedido!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        carrito.vaciar(); // ← Método correcto
                                        Navigator.pop(
                                            context); // Cierra diálogo
                                        Navigator.pop(
                                            context); // Vuelve al menú
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: const Text('Confirmar Pedido'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
