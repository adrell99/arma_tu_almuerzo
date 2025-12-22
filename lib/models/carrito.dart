import 'package:flutter/foundation.dart';
import 'item_menu.dart'; // Asegúrate de que MenuItem esté definido aquí
import 'package:collection/collection.dart'; // Para firstWhereOrNull

class ItemCarrito {
  final MenuItem item;
  int cantidad;

  ItemCarrito({required this.item, this.cantidad = 1});
}

class CarritoProvider with ChangeNotifier {
  final List<ItemCarrito> _items = [];

  // Getter para obtener una copia inmutable de los items
  List<ItemCarrito> get items => List.unmodifiable(_items);

  // Cantidad total de productos (suma de todas las cantidades)
  int get cantidadTotal {
    return _items.fold(0, (sum, item) => sum + item.cantidad);
  }

  // Precio total del carrito
  double get total {
    return _items.fold(
        0.0, (sum, item) => sum + (item.item.precio * item.cantidad));
  }

  // Agregar un item al carrito
  void agregar(MenuItem nuevoItem) {
    final existente =
        _items.firstWhereOrNull((i) => i.item.nombre == nuevoItem.nombre);

    if (existente != null) {
      existente.cantidad++;
    } else {
      _items.add(ItemCarrito(item: nuevoItem));
    }
    notifyListeners();
  }

  // Remover una unidad o eliminar si llega a 0
  void remover(MenuItem itemAEliminar) {
    final existente =
        _items.firstWhereOrNull((i) => i.item.nombre == itemAEliminar.nombre);

    if (existente != null) {
      if (existente.cantidad > 1) {
        existente.cantidad--;
      } else {
        _items.remove(existente);
      }
      notifyListeners();
    }
  }

  // Eliminar completamente un producto del carrito (independiente de la cantidad)
  void eliminarCompletamente(MenuItem itemAEliminar) {
    _items.removeWhere((i) => i.item.nombre == itemAEliminar.nombre);
    notifyListeners();
  }

  // Limpiar/vaciar el carrito
  void vaciar() {
    _items.clear();
    notifyListeners();
  }

  // Alias de vaciar, por si prefieres "limpiar"
  void limpiar() {
    vaciar();
  }
}
