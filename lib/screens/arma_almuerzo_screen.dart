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
  int _currentStep = 0;
  final Map<String, MenuItem?> _selecciones = {
    'proteina': null,
    'arroz': null,
    'ensalada': null,
    'bebida': null,
    'extra': null,
  };

  final List<String> _categorias = [
    'proteina',
    'arroz',
    'ensalada',
    'bebida',
    'extra'
  ];

  double get _totalActual {
    return _selecciones.values
        .where((item) => item != null)
        .fold(0, (sum, item) => sum + item!.precio);
  }

  void _agregarAlCarrito() {
    final carrito = Provider.of<CarritoProvider>(context, listen: false);
    for (var item in _selecciones.values) {
      if (item != null) carrito.agregar(item);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('¡Almuerzo personalizado agregado al carrito!')),
    );
    Navigator.pop(context);
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
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _categorias.length - 1) {
            setState(() => _currentStep += 1);
          } else {
            _agregarAlCarrito();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep -= 1);
        },
        controlsBuilder: (context, details) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(
                  _currentStep == _categorias.length - 1
                      ? 'Agregar al carrito'
                      : 'Siguiente',
                ),
              ),
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Atrás'),
                ),
            ],
          );
        },
        steps: _categorias.map((cat) {
          final nombreCat = cat[0].toUpperCase() + cat.substring(1);
          return Step(
            title: Text(nombreCat),
            subtitle: _selecciones[cat] != null
                ? Text(_selecciones[cat]!.nombre)
                : null,
            content: Column(
              children: opcionesPersonalizadas[cat]!.map((item) {
                final seleccionado = _selecciones[cat] == item;
                return ListTile(
                  title: Text(item.nombre),
                  subtitle: Text(
                    '${item.descripcion} - \$${item.precio.toStringAsFixed(0)}',
                  ),
                  leading: Icon(
                    seleccionado
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: seleccionado
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  onTap: () => setState(() => _selecciones[cat] = item),
                  selected: seleccionado,
                  selectedTileColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.08), // ✅ reemplazo moderno
                );
              }).toList(),
            ),
            isActive: _currentStep >= _categorias.indexOf(cat),
            state: _selecciones[cat] != null
                ? StepState.complete
                : StepState.editing,
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Total actual: \$${_totalActual.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
