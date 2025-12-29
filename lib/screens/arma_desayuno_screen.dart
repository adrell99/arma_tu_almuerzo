// lib/screens/arma_desayuno_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item_menu.dart';
import '../providers/carrito_provider.dart';

final Map<String, List<MenuItem>> opcionesDesayuno = {
  "proteinas": [
    MenuItem(
        nombre: "Huevos Revueltos",
        descripcion: "3 huevos revueltos",
        precio: 6000,
        categoria: "proteinas",
        imagen: "assets/images/desayunos/huevos_revueltos.jpg"),
    MenuItem(
        nombre: "Huevos Pericos",
        descripcion: "Con tomate y cebollín",
        precio: 7000,
        categoria: "proteinas",
        imagen: "assets/images/desayunos/pericos.jpg"),
    MenuItem(
        nombre: "Huevos Fritos",
        descripcion: "2 huevos fritos",
        precio: 6000,
        categoria: "proteinas",
        imagen: "assets/images/desayunos/fritos.jpg"),
    MenuItem(
        nombre: "Calentado",
        descripcion: "Frijoles con arroz del día anterior",
        precio: 8000,
        categoria: "proteinas",
        imagen: "assets/images/desayunos/calentado.jpg"),
  ],
  "carbohidratos": [
    MenuItem(
        nombre: "Arepa con Queso",
        descripcion: "Arepa asada con queso derretido",
        precio: 5000,
        categoria: "carbohidratos",
        imagen: "assets/images/desayunos/arepa.jpg"),
    MenuItem(
        nombre: "Pan de Bono",
        descripcion: "Recién horneado",
        precio: 3000,
        categoria: "carbohidratos",
        imagen: "assets/images/desayunos/bono.jpg"),
    MenuItem(
        nombre: "Bollo de Yuca",
        descripcion: "Tradicional costeño",
        precio: 4000,
        categoria: "carbohidratos",
        imagen: "assets/images/desayunos/bollo.jpg"),
  ],
  "acompanantes": [
    MenuItem(
        nombre: "Queso Costeño",
        descripcion: "Porción generosa",
        precio: 4000,
        categoria: "acompanantes",
        imagen: "assets/images/desayunos/queso.jpg"),
    MenuItem(
        nombre: "Chicharrón",
        descripcion: "Crujiente y dorado",
        precio: 8000,
        categoria: "acompanantes",
        imagen: "assets/images/desayunos/chicharron.jpg"),
    MenuItem(
        nombre: "Aguacate",
        descripcion: "Medio aguacate hass",
        precio: 4000,
        categoria: "acompanantes",
        imagen: "assets/images/desayunos/aguacate.jpg"),
  ],
  "bebidas": [
    MenuItem(
        nombre: "Jugo Natural",
        descripcion: "Naranja, mandarina o mango",
        precio: 6000,
        categoria: "bebidas",
        imagen: "assets/images/desayunos/jugo.jpg"),
    MenuItem(
        nombre: "Café con Leche",
        descripcion: "Taza grande",
        precio: 4000,
        categoria: "bebidas",
        imagen: "assets/images/desayunos/cafe.jpg"),
    MenuItem(
        nombre: "Chocolate Caliente",
        descripcion: "Con queso opcional",
        precio: 5000,
        categoria: "bebidas",
        imagen: "assets/images/desayunos/chocolate.jpg"),
    MenuItem(
        nombre: "Aromática",
        descripcion: "Hierbas naturales",
        precio: 3000,
        categoria: "bebidas",
        imagen: "assets/images/desayunos/aromatica.jpg"),
  ],
};

class ArmaDesayunoScreen extends StatefulWidget {
  const ArmaDesayunoScreen({super.key});

  @override
  State<ArmaDesayunoScreen> createState() => _ArmaDesayunoScreenState();
}

class _ArmaDesayunoScreenState extends State<ArmaDesayunoScreen> {
  final Map<String, int> _cantidades = {};
  final List<String> _categorias = opcionesDesayuno.keys.toList();
  late final Map<String, MenuItem> _itemsPorNombre;

  @override
  void initState() {
    super.initState();
    _itemsPorNombre = {};
    for (var cat in _categorias) {
      for (var item in opcionesDesayuno[cat]!) {
        _itemsPorNombre[item.nombre] = item;
      }
    }
  }

  List<MapEntry<String, int>> get _selectedEntries {
    return _cantidades.entries.where((e) => e.value > 0).toList();
  }

  double get _totalActual {
    return _selectedEntries.fold(0, (sum, entry) {
      final item = _itemsPorNombre[entry.key]!;
      return sum + (item.precio * entry.value);
    });
  }

  void _incrementar(MenuItem item) {
    setState(() {
      _cantidades.update(item.nombre, (v) => v + 1, ifAbsent: () => 1);
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

  void _agregarAlCarrito() {
    if (_selectedEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un ítem')),
      );
      return;
    }

    final provider = Provider.of<CarritoProvider>(context, listen: false);

    // Usamos listas para todo (compatible con el nuevo modelo)
    List<String> proteinas = [];
    List<String> carbohidratos = [];
    List<String> ensaladas = []; // Aquí vamos a poner los acompañantes
    List<String> bebidas = [];
    List<String> extras =
        []; // No hay extras en desayuno, pero lo dejamos vacío

    for (var entry in _selectedEntries) {
      final item = _itemsPorNombre[entry.key]!;
      final cant = entry.value;
      final texto = cant > 1 ? '$cant x ${item.nombre}' : item.nombre;

      switch (item.categoria) {
        case "proteinas":
          proteinas.add(texto);
          break;
        case "carbohidratos":
          carbohidratos.add(texto);
          break;
        case "acompanantes":
          ensaladas.add(
              texto); // Usamos el campo "ensaladas" para mostrar acompañantes
          break;
        case "bebidas":
          bebidas.add(texto);
          break;
      }
    }

    // Creamos usando el modelo actualizado (todo listas)
    final desayuno = AlmuerzoPersonalizado(
      proteinas: proteinas,
      carbohidratos: carbohidratos,
      ensaladas: ensaladas, // Aquí aparecen los acompañantes
      bebidas: bebidas,
      extras: extras,
      precioTotal: _totalActual,
    );

    provider.agregarAlmuerzoPersonalizado(desayuno);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Desayuno personalizado agregado al carrito! ☕'),
        backgroundColor: Colors.amber,
      ),
    );

    setState(() => _cantidades.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arma Tu Desayuno 🥚'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _categorias.length,
            itemBuilder: (context, index) {
              final cat = _categorias[index];
              final nombreCat = cat[0].toUpperCase() + cat.substring(1);
              final items = opcionesDesayuno[cat]!;

              return Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ExpansionTile(
                  iconColor: Colors.amber,
                  collapsedIconColor: Colors.amber,
                  title: Text(
                    nombreCat,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                  children: items.map((item) {
                    final cant = _cantidades[item.nombre] ?? 0;
                    return Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(item.imagen),
                          radius: 30,
                          backgroundColor: Colors.amber[100],
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.image, color: Colors.grey),
                        ),
                        title: Text(item.nombre,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item.descripcion),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed:
                                  cant > 0 ? () => _decrementar(item) : null,
                              icon: const Icon(Icons.remove),
                              color: cant > 0 ? Colors.amber[800] : Colors.grey,
                            ),
                            Text('$cant',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () => _incrementar(item),
                              icon: const Icon(Icons.add, color: Colors.green),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '\$${item.precio.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          if (_selectedEntries.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total: \$${_totalActual.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _agregarAlCarrito,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Agregar al carrito ☕',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
