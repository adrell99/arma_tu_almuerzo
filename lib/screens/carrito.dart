// lib/screens/carrito.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/item_menu.dart'; // ← Asegúrate de que este import esté aquí para definir MenuItem
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

    for (int i = 0; i < provider.almuerzosPersonalizados.length; i++) {
      final almuerzo = provider.almuerzosPersonalizados[i];
      detallePedido += "*Almuerzo Personalizado* 🍱\n";
      detallePedido += almuerzo.detalleFormateado;
      detallePedido +=
          "Precio: \$${almuerzo.precioTotal.toStringAsFixed(0)}\n\n";
    }

    if (provider.itemsNormales.isNotEmpty) {
      detallePedido += "*Menús Fijos / Extras:*\n";
      for (var item in provider.itemsNormales) {
        detallePedido +=
            "• ${item.nombre}: ${item.descripcion} - \$${item.precio.toStringAsFixed(0)}\n";
      }
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

*Pedido:*
$detallePedido

*Nota:* $nota

*Total a pagar:* \$${provider.total.toStringAsFixed(0)}

*Código de verificación:* #$codigoVerificacion (No edites este mensaje para que sea válido)

¡Gracias por tu pedido! Te confirmaremos pronto 🚀
""";

    final String tuNumeroWhatsApp = "573176496806";

    final Uri whatsappAppUri = Uri(
      scheme: 'whatsapp',
      host: 'send',
      queryParameters: {
        'phone': tuNumeroWhatsApp,
        'text': mensaje,
      },
    );

    if (await canLaunchUrl(whatsappAppUri)) {
      await launchUrl(whatsappAppUri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Abriendo WhatsApp con tu pedido listo!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final Uri whatsappWebUri = Uri.parse(
        "https://wa.me/$tuNumeroWhatsApp?text=${Uri.encodeComponent(mensaje)}",
      );

      if (await canLaunchUrl(whatsappWebUri)) {
        await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Abriendo WhatsApp en navegador...'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'No se pudo abrir WhatsApp. Instala la app o verifica conexión.'),
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...almuerzos.asMap().entries.map((entry) {
                        int index = entry.key;
                        AlmuerzoPersonalizado almuerzo = entry.value;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: const Text("Almuerzo Personalizado",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(almuerzo.detalleFormateado.trim()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${almuerzo.precioTotal.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _eliminarAlmuerzo(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      ...itemsNormales.map((item) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(item.nombre),
                            subtitle: Text(item.descripcion),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${item.precio.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                      const Divider(height: 30),
                      Text(
                        'Total: \$${provider.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Completa tus datos para el pedido',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                    'Ej: Sin cebolla, timbre fuerte, etc.',
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
                )
              : const Center(
                  child: Text(
                    'Tu carrito está vacío',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
        );
      },
    );
  }
}
