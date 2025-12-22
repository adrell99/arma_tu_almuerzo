// ignore: duplicate_ignore
// ignore: file_names, duplicate_ignore
// ignore: file_names
// lib/providers/carrito_provider.dart
// ignore_for_file: file_names

import 'package:arma_tu_almuerzo/models/item_menu.dart';
import 'package:flutter/material.dart';
// Asegúrate de que la ruta sea correcta

class CarritoProvider extends ChangeNotifier {
  final List<MenuItem> _items = []; // Lista de items en el carrito
  List<MenuItem> get items => _items;

  double get total {
    return _items.fold(0, (sum, item) => sum + item.precio);
  }

  int get cantidad => _items.length;

  void agregar(MenuItem item) {
    _items.add(item);
    notifyListeners(); // Importante: notifica a los listeners
  }

  void remover(MenuItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void vaciar() {
    _items.clear();
    notifyListeners();
  }
}
