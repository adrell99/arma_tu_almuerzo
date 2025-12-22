// lib/screens/menu_fijo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/menu_data.dart';
import '../models/carrito.dart';
import 'carrito.dart';

class MenuFijoScreen extends StatelessWidget {
  const MenuFijoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú del Día'),
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
        itemCount: menuFijo.length,
        itemBuilder: (context, index) {
          final item = menuFijo[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(item.nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.descripcion),
              trailing: Text('\$${item.precio.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                Provider.of<CarritoProvider>(context, listen: false)
                    .agregar(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.nombre} agregado al carrito')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
