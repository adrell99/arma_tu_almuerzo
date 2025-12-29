// lib/models/item_menu.dart

class MenuItem {
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final String imagen; // ← Campo para la ruta de la imagen

  MenuItem({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.imagen,
  });
}

class AlmuerzoPersonalizado {
  final List<String> proteinas;
  final List<String> carbohidratos;
  final List<String> ensaladas;
  final List<String> bebidas;
  final List<String> extras;
  final double precioTotal;

  AlmuerzoPersonalizado({
    required this.proteinas,
    required this.carbohidratos,
    required this.ensaladas,
    required this.bebidas,
    required this.extras,
    required this.precioTotal,
  });

  // Método útil para mostrar el almuerzo en el carrito o en resúmenes
  String get descripcion {
    List<String> partes = [];

    if (proteinas.isNotEmpty) {
      partes.add('Proteínas: ${proteinas.join(', ')}');
    }
    if (carbohidratos.isNotEmpty) {
      partes.add('Carbohidratos: ${carbohidratos.join(', ')}');
    }
    if (ensaladas.isNotEmpty) {
      partes.add('Ensaladas: ${ensaladas.join(', ')}');
    }
    if (bebidas.isNotEmpty) {
      partes.add('Bebidas: ${bebidas.join(', ')}');
    }
    if (extras.isNotEmpty) {
      partes.add('Extras: ${extras.join(', ')}');
    }

    return partes.isEmpty ? 'Almuerzo personalizado' : partes.join(' | ');
  }

  // Opcional: para debugging o logs
  @override
  String toString() {
    return 'AlmuerzoPersonalizado(proteinas: $proteinas, carbohidratos: $carbohidratos, ensaladas: $ensaladas, bebidas: $bebidas, extras: $extras, total: $precioTotal)';
  }
}
