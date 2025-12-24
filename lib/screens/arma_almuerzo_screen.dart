// lib/screens/arma_almuerzo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/menu_data.dart';
import '../models/carrito.dart';
import '../models/item_menu.dart';
import 'carrito.dart';

class ArmaAlmuerzoScreen extends StatefulWidget {
  const ArmaAlmuerzoScreen({super.key});

  @override
  State<ArmaAlmuerzoScreen> createState() => _ArmaAlmuerzoScreenState();
}

class _ArmaAlmuerzoScreenState extends State<ArmaAlmuerzoScreen> {
  // Mapa: item -> cantidad seleccionada
  final Map<MenuItem, int> _cantidades = {};

  final List<String> _categorias = opcionesPersonalizadas.keys.toList();

  // Lista de items con cantidad > 0
  List<MapEntry<MenuItem, int>> get _selectedEntries {
    return _cantidades.entries.where((e) => e.value > 0).toList();
  }

  double get _totalActual {
    return _selectedEntries.fold(
        0, (sum, entry) => sum + (entry.key.precio * entry.value));
  }

  void _incrementar(MenuItem item) {
    setState(() {
      _cantidades.update(item, (value) => value + 1, ifAbsent: () => 1);
    });
  }

  void _decrementar(MenuItem item) {
    setState(() {
      final current = _cantidades[item] ?? 0;
      if (current > 1) {
        _cantidades[item] = current - 1;
      } else {
        _cantidades.remove(item);
      }
    });
  }

  void _agregarAlCarrito() {
    if (_selectedEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un ítem')),
      );
      return;
    }

    final carrito = Provider.of<CarritoProvider>(context, listen: false);

    // Crear descripción detallada con cantidades
    final String detalles =
        _selectedEntries.map((e) => "${e.value}x ${e.key.nombre}").join(', ');

    final String desc = "Incluye: $detalles";
    final double total = _totalActual;

    final MenuItem customItem = MenuItem(
      nombre: "Almuerzo Personalizado",
      descripcion: desc,
      precio: total,
      categoria: "personalizado",
    );

    // Agregar solo una vez el paquete completo (con todo multiplicado ya en el precio)
    carrito.agregar(customItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('¡Almuerzo personalizado agregado al carrito!')),
    );

    setState(() {
      _cantidades.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arma Tu Almuerzo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CarritoScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final cat = _categorias[index];
                final nombreCat = cat[0].toUpperCase() + cat.substring(1);
                final items = opcionesPersonalizadas[cat]!;
                return ExpansionTile(
                  title: Text(nombreCat),
                  children: items.map((item) {
                    final cantidad = _cantidades[item] ?? 0;
                    return ListTile(
                      title: Text(item.nombre),
                      subtitle: Text(
                        '${item.descripcion} - \$${item.precio.toStringAsFixed(0)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.red,
                            onPressed:
                                cantidad > 0 ? () => _decrementar(item) : null,
                          ),
                          Text(
                            '$cantidad',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: Colors.green,
                            onPressed: () => _incrementar(item),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          // Sección de seleccionados (compacta)
          if (_selectedEntries.isNotEmpty)
            Container(
              height: 150,
              color: Colors.grey[200],
              padding: const EdgeInsets.all(4),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Items seleccionados:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    ..._selectedEntries.map((entry) {
                      final item = entry.key;
                      final cant = entry.value;
                      final subtotal = item.precio * cant;
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: Text("${cant}x ${item.nombre}",
                            style: const TextStyle(fontSize: 12)),
                        subtitle: Text('Subtotal: \$$subtotal',
                            style: const TextStyle(fontSize: 10)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 18),
                          onPressed: () =>
                              _decrementar(item), // Quita todas las unidades
                        ),
                      );
                    }),
                    const Divider(thickness: 0.5),
                    Text(
                      'Total: \$${_totalActual.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _agregarAlCarrito,
          child: const Text('Agregar al carrito'),
        ),
      ),
    );
  }
}
