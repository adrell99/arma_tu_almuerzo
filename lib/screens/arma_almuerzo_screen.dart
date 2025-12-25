// lib/screens/arma_almuerzo_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/menu_data.dart';
import '../models/item_menu.dart';
import '../providers/carrito_provider.dart';
import 'carrito.dart';

class ArmaAlmuerzoScreen extends StatefulWidget {
  const ArmaAlmuerzoScreen({super.key});

  @override
  State<ArmaAlmuerzoScreen> createState() => _ArmaAlmuerzoScreenState();
}

class _ArmaAlmuerzoScreenState extends State<ArmaAlmuerzoScreen> {
  final Map<MenuItem, int> _cantidades = {};

  final List<String> _categorias = opcionesPersonalizadas.keys.toList();

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

    final provider = Provider.of<CarritoProvider>(context, listen: false);

    String proteina = "Ninguna";
    List<String> carbohidratos = [];
    String ensalada = "Ninguna";
    String? bebida;
    List<String> extras = [];

    for (var entry in _selectedEntries) {
      final item = entry.key;
      final cant = entry.value;
      final nombreConCant = "${cant > 1 ? '$cant x ' : ''}${item.nombre}";

      if (item.categoria == "proteinas") {
        proteina = nombreConCant;
      } else if (item.categoria == "carbohidratos") {
        carbohidratos.add(nombreConCant);
      } else if (item.categoria == "ensaladas") {
        ensalada = nombreConCant;
      } else if (item.categoria == "bebidas") {
        bebida = nombreConCant;
      } else if (item.categoria == "extras") {
        extras.add(nombreConCant);
      }
    }

    final almuerzo = AlmuerzoPersonalizado(
      proteina: proteina,
      carbohidratos: carbohidratos,
      ensalada: ensalada,
      bebida: bebida,
      extras: extras,
      precioTotal: _totalActual,
    );

    provider.agregarAlmuerzoPersonalizado(almuerzo);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Almuerzo personalizado agregado al carrito! 🍱'),
        backgroundColor: Colors.green,
      ),
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
          // Sección de seleccionados (como antes, height 150 con scroll sin barra visible)
          if (_selectedEntries.isNotEmpty)
            Container(
              height: 150,
              color: Colors.grey[200],
              padding: const EdgeInsets.all(4),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false), // ← CAMBIO: Oculta la barra de scroll
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Items seleccionados:',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
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
                            onPressed: () {
                              setState(() {
                                _cantidades
                                    .remove(item); // Quita todas las unidades
                              });
                            },
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
