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
  final Map<String, int> _cantidades = {};

  final List<String> _categorias = opcionesPersonalizadas.keys.toList();

  List<MapEntry<String, int>> get _selectedEntries {
    return _cantidades.entries.where((e) => e.value > 0).toList();
  }

  MenuItem _getItemByNombre(String nombre) {
    for (var cat in _categorias) {
      for (var item in opcionesPersonalizadas[cat]!) {
        if (item.nombre == nombre) return item;
      }
    }
    throw Exception('Item no encontrado: $nombre');
  }

  double get _totalActual {
    return _selectedEntries.fold(0, (sum, entry) {
      final item = _getItemByNombre(entry.key);
      return sum + (item.precio * entry.value);
    });
  }

  void _incrementar(MenuItem item) {
    setState(() {
      _cantidades.update(item.nombre, (value) => value + 1, ifAbsent: () => 1);
    });
  }

  void _decrementar(MenuItem item) {
    setState(() {
      final current = _cantidades[item.nombre] ?? 0;
      if (current > 1) {
        _cantidades[item.nombre] = current - 1;
      } else {
        _cantidades.remove(item.nombre);
      }
    });
  }

  void _quitarItem(MenuItem item) {
    setState(() {
      _cantidades.remove(item.nombre);
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
      final item = _getItemByNombre(entry.key);
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

  void _mostrarRevisionPedido() {
    Map<String, List<MapEntry<String, int>>> itemsPorCategoria = {};
    for (var entry in _selectedEntries) {
      final item = _getItemByNombre(entry.key);
      final categoria = item.categoria;
      itemsPorCategoria.putIfAbsent(categoria, () => []);
      itemsPorCategoria[categoria]!.add(entry);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.92,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                'Revisa tu almuerzo personalizado',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: itemsPorCategoria.entries.map((catEntry) {
                  final categoriaKey = catEntry.key;
                  final nombreCategoria =
                      categoriaKey[0].toUpperCase() + categoriaKey.substring(1);
                  final items = catEntry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          nombreCategoria,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      ...items.map((entry) {
                        final item = _getItemByNombre(entry.key);
                        final cant = entry.value;
                        final subtotal = item.precio * cant;

                        return Card(
                          elevation: 6,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "$cant x ${item.nombre}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '\$${subtotal.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  item.descripcion,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -4)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${_totalActual.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                                color: Colors.orange, width: 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text(
                            'Corregir',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _agregarAlCarrito();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 8,
                          ),
                          child: const Text(
                            'Agregar al carrito',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arma Tu Almuerzo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
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
              padding: const EdgeInsets.all(16),
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final cat = _categorias[index];
                final nombreCat = cat[0].toUpperCase() + cat.substring(1);
                final items = opcionesPersonalizadas[cat]!;

                return Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ExpansionTile(
                    iconColor: Colors.orange,
                    collapsedIconColor: Colors.orange,
                    title: Text(
                      nombreCat,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    children: items.map((item) {
                      final cantidad = _cantidades[item.nombre] ?? 0;
                      final bool puedeDecrementar = cantidad > 0;

                      return Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // IMAGEN DINÁMICA CON FALLBACK Y ERROR HANDLING
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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

                            // Degradado oscuro → CORREGIDO: con withValues()
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.4),
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),

                            // Contenido: textos y botones
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                          ],
                                        ),
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
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // Fondo blanco semitransparente → CORREGIDO: con withValues()
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.orange, width: 2),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 6),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                                minWidth: 32, minHeight: 32),
                                            icon: Icon(
                                              Icons.remove,
                                              color: puedeDecrementar
                                                  ? Colors.orange[800]!
                                                  : Colors.grey,
                                            ),
                                            onPressed: puedeDecrementar
                                                ? () => _decrementar(item)
                                                : null,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text(
                                              '$cantidad',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                          IconButton(
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                                minWidth: 32, minHeight: 32),
                                            icon: const Icon(Icons.add,
                                                color: Colors.green),
                                            onPressed: () => _incrementar(item),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          if (_selectedEntries.isNotEmpty)
            Container(
              height: 260,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, -6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tu almuerzo personalizado',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _selectedEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _selectedEntries[index];
                        final item = _getItemByNombre(entry.key);
                        final cant = entry.value;
                        final subtotal = item.precio * cant;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("$cant x ${item.nombre}",
                                    style: const TextStyle(fontSize: 17)),
                              ),
                              Text('\$${subtotal.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange)),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.orange[700], size: 28),
                                onPressed: () => _quitarItem(item),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(thickness: 1.2, color: Colors.orange),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('\$${_totalActual.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: _selectedEntries.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: ElevatedButton(
                onPressed: _mostrarRevisionPedido,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                ),
                child: const Text(
                  'Revisar pedido',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }
}

