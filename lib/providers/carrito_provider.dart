// lib/providers/carrito_provider.dart
import 'package:flutter/material.dart';
import '../models/item_menu.dart'; // Ajusta la ruta si es necesario

// Clase para representar un almuerzo personalizado con todo su detalle
class AlmuerzoPersonalizado {
  final String proteina;
  final List<String> carbohidratos;
  final String ensalada;
  final String? bebida;
  final List<String> extras;
  final double precioTotal;

  AlmuerzoPersonalizado({
    required this.proteina,
    required this.carbohidratos,
    required this.ensalada,
    this.bebida,
    this.extras = const [],
    required this.precioTotal,
  });

  // Método para formatear bonito el detalle
  String get detalleFormateado {
    String detalle = "• Proteína: $proteina\n";
    detalle += "• Carbohidratos: ${carbohidratos.join(', ')}\n";
    detalle += "• Ensalada: $ensalada\n";
    if (bebida != null && bebida!.isNotEmpty) {
      detalle += "• Bebida: $bebida\n";
    }
    if (extras.isNotEmpty) {
      detalle += "• Extras: ${extras.join(', ')}\n";
    }
    return detalle;
  }
}

class CarritoProvider extends ChangeNotifier {
  // Ítems normales (bebidas, sopas, postres, etc.)
  final List<MenuItem> _itemsNormales = [];
  List<MenuItem> get itemsNormales => _itemsNormales;

  // Almuerzos personalizados (puede haber más de uno)
  final List<AlmuerzoPersonalizado> _almuerzosPersonalizados = [];
  List<AlmuerzoPersonalizado> get almuerzosPersonalizados =>
      _almuerzosPersonalizados;

  // Cantidad total de almuerzos (personalizados)
  int get cantidadAlmuerzos => _almuerzosPersonalizados.length;

  // Todos los ítems para mostrar en pantalla (opcional)
  int get cantidadTotalItems =>
      _itemsNormales.length + _almuerzosPersonalizados.length;

  // Precio total completo
  double get total {
    double totalAlmuerzos =
        _almuerzosPersonalizados.fold(0, (sum, a) => sum + a.precioTotal);
    double totalNormales =
        _itemsNormales.fold(0, (sum, item) => sum + item.precio);
    return totalAlmuerzos + totalNormales;
  }

  // === MÉTODOS PARA ALMUERZOS PERSONALIZADOS ===
  void agregarAlmuerzoPersonalizado(AlmuerzoPersonalizado almuerzo) {
    _almuerzosPersonalizados.add(almuerzo);
    notifyListeners();
  }

  void removerAlmuerzoPersonalizado(int index) {
    if (index >= 0 && index < _almuerzosPersonalizados.length) {
      _almuerzosPersonalizados.removeAt(index);
      notifyListeners();
    }
  }

  // === MÉTODOS PARA ÍTEMS NORMALES ===
  void agregarItemNormal(MenuItem item) {
    _itemsNormales.add(item);
    notifyListeners();
  }

  void removerItemNormal(MenuItem item) {
    _itemsNormales.remove(item);
    notifyListeners();
  }

  void vaciarCarrito() {
    _itemsNormales.clear();
    _almuerzosPersonalizados.clear();
    notifyListeners();
  }
}
