import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../modelo/producto_modelo.dart';
import '../controlador/producto_controlador.dart';
import 'dart:io';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DetalleProductoVista extends StatefulWidget {
  final Producto producto;

  DetalleProductoVista({required this.producto});

  @override
  _DetalleProductoVistaState createState() => _DetalleProductoVistaState();
}

class _DetalleProductoVistaState extends State<DetalleProductoVista> {
  late Producto _productoActual;
  final ProductoControlador _controlador = ProductoControlador();

  @override
  void initState() {
    super.initState();
    _productoActual = widget.producto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_productoActual.nombre,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  )),
              background: Hero(
                tag: 'productImage${_productoActual.rutaImagen}',
                child: kIsWeb
                    ? Image.network(
                  _productoActual.rutaImagen,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  File(_productoActual.rutaImagen),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _productoActual.nombre,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _productoActual.detalle,
                              style: TextStyle(fontSize: 18, color: Colors.black87),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _editarProducto(context);
                              },
                              child: Text('Editar Producto'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                textStyle: TextStyle(fontSize: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editarProducto(BuildContext context) async {
    final controladorNombre = TextEditingController(text: _productoActual.nombre);
    final controladorDetalle = TextEditingController(text: _productoActual.detalle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Producto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controladorNombre,
                decoration: InputDecoration(labelText: "Nombre del producto"),
              ),
              TextField(
                controller: controladorDetalle,
                decoration: InputDecoration(labelText: "Detalle del producto"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                final productoEditado = Producto(
                  rutaImagen: _productoActual.rutaImagen,
                  nombre: controladorNombre.text,
                  detalle: controladorDetalle.text,
                );

                await _controlador.editarProducto(_productoActual.rutaImagen, productoEditado);

                Navigator.of(context).pop(productoEditado);

                _mostrarMensaje("Producto actualizado correctamente");
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}