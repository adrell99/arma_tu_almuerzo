// lib/screens/carrito.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http; // Para enviar al Google Sheet

import '../models/item_menu.dart';
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

    // === Construir detalle del pedido con secciones organizadas ===
    String detallePedido = "";

    final almuerzos = provider.almuerzosPersonalizados;
    final itemsNormales = provider.itemsNormales;

    // Separar ítems normales usando la propiedad 'categoria' (más flexible con .contains)
    final desayunos = itemsNormales
        .where((item) => item.categoria.toLowerCase().contains('desayuno'))
        .toList();

    final almuerzosFijos = itemsNormales
        .where((item) => !item.categoria.toLowerCase().contains('desayuno'))
        .toList();

    // Almuerzos Personalizados
    if (almuerzos.isNotEmpty) {
      detallePedido += "*Almuerzos Personalizados* 🍱\n\n";
      for (int i = 0; i < almuerzos.length; i++) {
        final almuerzo = almuerzos[i];
        detallePedido += "*Almuerzo Personalizado ${i + 1}:*\n";
        detallePedido += almuerzo.descripcion.trim() + "\n";
        detallePedido +=
            "*Precio:* \$${almuerzo.precioTotal.toStringAsFixed(0)}\n\n";
      }
    }

    // Desayunos (sección aparte con subtítulo claro)
    if (desayunos.isNotEmpty) {
      detallePedido += "*Desayunos* ☕\n";
      for (var item in desayunos) {
        detallePedido += "• ${item.nombre}";
        if (item.descripcion.isNotEmpty) {
          detallePedido += " - ${item.descripcion}";
        }
        detallePedido += " \$${item.precio.toStringAsFixed(0)}\n";
      }
      detallePedido += "\n";
    }

    // Almuerzos del Menú Fijo (solo los que no son desayuno)
    if (almuerzosFijos.isNotEmpty) {
      detallePedido += "*Almuerzos del Menú Fijo* 🍲\n";
      for (var item in almuerzosFijos) {
        detallePedido += "• ${item.nombre}";
        if (item.descripcion.isNotEmpty) {
          detallePedido += " - ${item.descripcion}";
        }
        detallePedido += " \$${item.precio.toStringAsFixed(0)}\n";
      }
      detallePedido += "\n";
    }

    String nota = _notaController.text.trim().isEmpty
        ? "Sin nota adicional"
        : _notaController.text.trim();

    String codigo = DateTime.now()
        .millisecondsSinceEpoch
        .remainder(1000000)
        .toString()
        .padLeft(6, '0');

    // === 1. ENVIAR COPIA AL GOOGLE SHEET ===
    const String webhookUrl =
        "https://script.google.com/macros/s/AKfycbwi5ww3fl9iDJTEDeZE2ELcavRALpPCR55i-lqhPpKEbjCxKyoudxXFRmGX0AjQiToQtQ/exec";

    final Map<String, dynamic> datosPedido = {
      "nombre": _nombreController.text.trim(),
      "telefono": _telefonoController.text.trim(),
      "direccion": _direccionController.text.trim(),
      "detallePedido": detallePedido,
      "nota": nota,
      "total": provider.total.toStringAsFixed(0),
      "codigo": codigo,
    };

    http.post(
      Uri.parse(webhookUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(datosPedido),
    );

    // === 2. ABRIR WHATSAPP ===
    String mensajeCliente = """
*NUEVO PEDIDO* 🍱

*Nombre:* ${_nombreController.text.trim()}
*Teléfono:* ${_telefonoController.text.trim()}
*Dirección / Barrio:* ${_direccionController.text.trim()}

*Detalle del pedido:*
$detallePedido

*Nota:* $nota

*Total a pagar:* \$${provider.total.toStringAsFixed(0)}

*Código de verificación:* #$codigo

¡Gracias por tu pedido! Te confirmaremos pronto 🚀
"""
        .trim();

    final String numeroPrincipal = "573176496806";

    final Uri whatsappUri = Uri(
      scheme: 'whatsapp',
      host: 'send',
      queryParameters: {
        'phone': numeroPrincipal,
        'text': mensajeCliente,
      },
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se pudo abrir WhatsApp');
      }
    } catch (e) {
      final Uri webUri = Uri.parse(
        "https://wa.me/$numeroPrincipal?text=${Uri.encodeComponent(mensajeCliente)}",
      );
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al abrir WhatsApp'),
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
                                  children: [
                                    // Cubiertos cruzados (icono de plato con tenedor y cuchillo cruzados)
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.dining,
                                        size: 40,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Almuerzo Personalizado ${index + 1}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  almuerzo.descripcion,
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

                      // === Ítems normales (desayunos y almuerzos fijos) ===
                      ...itemsNormales.map((item) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item.imagen,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.fastfood,
                                        size: 50, color: Colors.orange),
                              ),
                            ),
                            title: Text(
                              item.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: item.descripcion.isEmpty
                                ? null
                                : Text(item.descripcion),
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

