// lib/providers/carrito_provider.dart

import 'package:flutter/material.dart';
import '../models/item_menu.dart'; // ← Aquí está la clase AlmuerzoPersonalizado correcta (con listas y método descripcion)

class CarritoProvider extends ChangeNotifier {
  // Ítems normales (bebidas, sopas, postres, menús fijos, etc.)
  final List<MenuItem> _itemsNormales = [];
  List<MenuItem> get itemsNormales => _itemsNormales;

  // Almuerzos personalizados (puede haber más de uno)
  final List<AlmuerzoPersonalizado> _almuerzosPersonalizados = [];
  List<AlmuerzoPersonalizado> get almuerzosPersonalizados =>
      _almuerzosPersonalizados;

  // Cantidad total de almuerzos personalizados
  int get cantidadAlmuerzos => _almuerzosPersonalizados.length;

  // Cantidad total de ítems en el carrito (almuerzos + normales)
  int get cantidadTotalItems =>
      _itemsNormales.length + _almuerzosPersonalizados.length;

  // Precio total completo del carrito
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

  // Vacía todo el carrito
  void vaciarCarrito() {
    _itemsNormales.clear();
    _almuerzosPersonalizados.clear();
    notifyListeners();
  }
}
