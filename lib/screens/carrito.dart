// lib/screens/carrito.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/item_menu.dart'; // ← Aquí está AlmuerzoPersonalizado con listas
import '../providers/carrito_provider.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _notaController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  void _eliminarAlmuerzo(int index) {
    final provider = Provider.of<CarritoProvider>(context, listen: false);
    provider.removerAlmuerzoPersonalizado(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Almuerzo eliminado del carrito')),
    );
  }

  void _eliminarItemNormal(MenuItem item) {
    final provider = Provider.of<CarritoProvider>(context, listen: false);
    provider.removerItemNormal(item);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ítem eliminado del carrito')),
    );
  }

  Future<void> _enviarPedidoPorWhatsApp() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor completa todos los campos obligatorios')),
      );
      return;
    }

    final provider = Provider.of<CarritoProvider>(context, listen: false);

    if (provider.cantidadTotalItems == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El carrito está vacío')),
      );
      return;
    }

    String detallePedido = "";

    // === Almuerzos Personalizados ===
    for (int i = 0; i < provider.almuerzosPersonalizados.length; i++) {
      final almuerzo = provider.almuerzosPersonalizados[i];
      detallePedido += "*Almuerzo Personalizado ${i + 1}* 🍱\n";
      detallePedido += almuerzo.descripcion; // ← Usa el método del modelo
      detallePedido +=
          "\n*Precio:* \$${almuerzo.precioTotal.toStringAsFixed(0)}\n\n";
    }

    // === Ítems normales (menús fijos, extras, etc.) ===
    if (provider.itemsNormales.isNotEmpty) {
      detallePedido += "*Otros ítems:*\n";
      for (var item in provider.itemsNormales) {
        detallePedido += "• ${item.nombre}";
        if (item.descripcion.isNotEmpty) {
          detallePedido += " - ${item.descripcion}";
        }
        detallePedido += " - \$${item.precio.toStringAsFixed(0)}\n";
      }
      detallePedido += "\n";
    }

    String nota = _notaController.text.trim().isEmpty
        ? "Sin nota adicional"
        : _notaController.text.trim();

    final String codigoVerificacion =
        DateTime.now().millisecondsSinceEpoch.toString().substring(6, 12);

    String mensaje = """
*NUEVO PEDIDO* 🍱

*Nombre:* ${_nombreController.text.trim()}
*Teléfono WhatsApp:* ${_telefonoController.text.trim()}
*Dirección / Barrio:* ${_direccionController.text.trim()}

*Detalle del pedido:*
$detallePedido

*Nota:* $nota

*Total a pagar:* \$${provider.total.toStringAsFixed(0)}

*Código de verificación:* #$codigoVerificacion 
(No edites este mensaje para que sea válido)

¡Gracias por tu pedido! Te confirmaremos pronto 🚀
""";

    final String tuNumeroWhatsApp = "573176496806"; // Cambia si es necesario

    final Uri whatsappUri = Uri(
      scheme: 'whatsapp',
      host: 'send',
      queryParameters: {
        'phone': tuNumeroWhatsApp,
        'text': mensaje,
      },
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Abriendo WhatsApp con tu pedido listo!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw 'No se pudo abrir WhatsApp';
      }
    } catch (e) {
      final Uri webUri = Uri.parse(
        "https://wa.me/$tuNumeroWhatsApp?text=${Uri.encodeComponent(mensaje)}",
      );
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Abriendo WhatsApp en navegador...')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Error al abrir WhatsApp. Verifica que tengas la app instalada.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarritoProvider>(
      builder: (context, provider, child) {
        final almuerzos = provider.almuerzosPersonalizados;
        final itemsNormales = provider.itemsNormales;
        final hayItems = provider.cantidadTotalItems > 0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Carrito'),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          body: hayItems
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumen de tu pedido',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      const SizedBox(height: 16),

                      // === Almuerzos Personalizados ===
                      ...almuerzos.asMap().entries.map((entry) {
                        int index = entry.key;
                        AlmuerzoPersonalizado almuerzo = entry.value;

                        return Card(
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.restaurant_menu,
                                        color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text(
                                      "Almuerzo Personalizado",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  almuerzo
                                      .descripcion, // ← Muestra todo bonito con listas
                                  style: const TextStyle(
                                      fontSize: 16, height: 1.5),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${almuerzo.precioTotal.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _eliminarAlmuerzo(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      // === Ítems normales ===
                      ...itemsNormales.map((item) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.fastfood,
                                color: Colors.orange),
                            title: Text(item.nombre,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(item.descripcion),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${item.precio.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _eliminarItemNormal(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const Divider(height: 40, thickness: 2),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total a pagar',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(
                            '\$${provider.total.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Formulario de datos
                      const Text('Completa tus datos',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                controller: _nombreController,
                                decoration: const InputDecoration(
                                    labelText: 'Nombre completo *',
                                    border: OutlineInputBorder()),
                                validator: (v) =>
                                    v!.trim().isEmpty ? 'Obligatorio' : null),
                            const SizedBox(height: 16),
                            TextFormField(
                                controller: _telefonoController,
                                decoration: const InputDecoration(
                                    labelText: 'Teléfono WhatsApp *',
                                    border: OutlineInputBorder()),
                                keyboardType: TextInputType.phone,
                                validator: (v) =>
                                    v!.trim().isEmpty ? 'Obligatorio' : null),
                            const SizedBox(height: 16),
                            TextFormField(
                                controller: _direccionController,
                                decoration: const InputDecoration(
                                    labelText: 'Dirección y barrio *',
                                    border: OutlineInputBorder()),
                                maxLines: 2,
                                validator: (v) =>
                                    v!.trim().isEmpty ? 'Obligatorio' : null),
                            const SizedBox(height: 16),
                            TextFormField(
                                controller: _notaController,
                                decoration: const InputDecoration(
                                    labelText: 'Nota adicional (opcional)',
                                    hintText:
                                        'Ej: Sin cebolla, timbre fuerte...',
                                    border: OutlineInputBorder()),
                                maxLines: 3),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Botón enviar
                      ElevatedButton(
                        onPressed: _enviarPedidoPorWhatsApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('Enviar Pedido por WhatsApp',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 100, color: Colors.grey),
                      SizedBox(height: 20),
                      Text('Tu carrito está vacío',
                          style: TextStyle(fontSize: 22, color: Colors.grey)),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
