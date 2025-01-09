import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelo/producto_modelo.dart';

class ProductoControlador extends ChangeNotifier {
  List<Producto> _productos = [];

  List<Producto> obtenerProductos() {
    return _productos;
  }

  void agregarProducto(Producto producto) {
    _productos.add(producto);
    _guardarProductosEnAlmacenamiento();
    notifyListeners();
  }

  void eliminarProducto(Producto producto) {
    _productos.removeWhere((p) => p.rutaImagen == producto.rutaImagen);
    _guardarProductosEnAlmacenamiento();
    notifyListeners();
  }

  Future<void> editarProducto(String rutaImagenOriginal, Producto productoEditado) async {
    final index = _productos.indexWhere((p) => p.rutaImagen == rutaImagenOriginal);
    if (index != -1) {
      _productos[index] = productoEditado;
      await _guardarProductosEnAlmacenamiento();
      notifyListeners();
    }
  }

  Future<void> cargarProductosDesdeAlmacenamiento() async {
    final prefs = await SharedPreferences.getInstance();
    final productosString = prefs.getString('productos');
    if (productosString != null) {
      final productosJson = jsonDecode(productosString) as List;
      _productos = productosJson.map((json) => Producto.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _guardarProductosEnAlmacenamiento() async {
    final prefs = await SharedPreferences.getInstance();
    final productosJson = _productos.map((p) => p.toJson()).toList();
    await prefs.setString('productos', jsonEncode(productosJson));
  }
}