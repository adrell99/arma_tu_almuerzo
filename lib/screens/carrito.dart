// lib/screens/carrito.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/carrito.dart';
import '../models/item_menu.dart';

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

  // Función para eliminar una unidad de un ítem (o todas si solo hay una)
  void _eliminarItem(MenuItem item) {
    final carritoProvider =
        Provider.of<CarritoProvider>(context, listen: false);
    carritoProvider.remover(item); // Usa tu método remover (quita una unidad)

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ítem eliminado del carrito'),
        duration: Duration(seconds: 1),
      ),
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

    final carritoProvider =
        Provider.of<CarritoProvider>(context, listen: false);
    final List<ItemCarrito> carritoItems = carritoProvider.items;

    if (carritoItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El carrito está vacío')),
      );
      return;
    }

    Map<MenuItem, int> agrupados = {};
    double total = 0.0;

    for (var itemCarrito in carritoItems) {
      final item = itemCarrito.item; // Cambia si tu campo se llama diferente
      agrupados[item] = (agrupados[item] ?? 0) + itemCarrito.cantidad;
      total += item.precio * itemCarrito.cantidad;
    }

    String detallePedido =
        agrupados.entries.map((e) => "${e.value}x ${e.key.nombre}").join('\n');

    String nota = _notaController.text.trim().isEmpty
        ? "Sin nota adicional"
        : _notaController.text.trim();

    String mensaje = """
*NUEVO PEDIDO* 🍱

*Nombre:* ${_nombreController.text.trim()}
*Teléfono WhatsApp:* ${_telefonoController.text.trim()}
*Dirección / Barrio:* ${_direccionController.text.trim()}

*Pedido:*
$detallePedido

*Nota:* $nota

*Total a pagar:* \$${total.toStringAsFixed(0)}

¡Gracias por tu pedido! Te confirmaremos pronto 🚀
""";

    // === TU NÚMERO DE WHATSAPP REAL (con código de país, sin + ni espacios) ===
    final String tuNumeroWhatsApp = "573176496806"; // ← CAMBIA AQUÍ

    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$tuNumeroWhatsApp?text=${Uri.encodeComponent(mensaje)}",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Pedido enviado por WhatsApp!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<CarritoProvider>(context);
    final List<ItemCarrito> carritoItems = carritoProvider.items;

    double total = 0.0;
    for (var itemCarrito in carritoItems) {
      total += itemCarrito.item.precio * itemCarrito.cantidad;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
      ),
      body: carritoItems.isEmpty
          ? const Center(
              child: Text(
                'Tu carrito está vacío',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen de tu pedido',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: carritoItems.length,
                    itemBuilder: (context, index) {
                      final itemCarrito = carritoItems[index];
                      final item = itemCarrito.item;
                      return Card(
                        child: ListTile(
                          title:
                              Text("${itemCarrito.cantidad}x ${item.nombre}"),
                          subtitle: Text(
                            item.descripcion,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${(item.precio * itemCarrito.cantidad).toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _eliminarItem(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 30),
                  Text(
                    'Total: \$${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Completa tus datos para el pedido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre completo *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value!.trim().isEmpty ? 'Obligatorio' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefonoController,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono WhatsApp *',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.trim().isEmpty ? 'Obligatorio' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _direccionController,
                          decoration: const InputDecoration(
                            labelText: 'Dirección y barrio *',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          validator: (value) =>
                              value!.trim().isEmpty ? 'Obligatorio' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notaController,
                          decoration: const InputDecoration(
                            labelText: 'Nota adicional (opcional)',
                            hintText:
                                'Ej: En alitas sacar ensalada, timbre fuerte, etc.',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _enviarPedidoPorWhatsApp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Enviar Pedido por WhatsApp',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
