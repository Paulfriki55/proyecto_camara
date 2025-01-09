import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../controlador/producto_controlador.dart';
import '../modelo/producto_modelo.dart';
import 'detalle_producto_vista.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final ImagePicker _selectorDeImagenes = ImagePicker();


  @override
  void initState() {
    super.initState();
  }


  Future<void> agregarProducto() async {
    final archivoSeleccionado = await _selectorDeImagenes.pickImage(
      source: ImageSource.camera,
    );

    if (archivoSeleccionado != null) {
      final controladorNombre = TextEditingController();
      final controladorDetalle = TextEditingController();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Agregar Producto"),
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
                  final nuevoProducto = Producto(
                    rutaImagen: archivoSeleccionado.path,
                    nombre: controladorNombre.text,
                    detalle: controladorDetalle.text,
                  );
                  Provider.of<ProductoControlador>(context, listen: false).agregarProducto(nuevoProducto);
                  Navigator.of(context).pop();
                  _mostrarMensaje("Producto agregado a la Lista de Productos");
                },
                child: Text("Guardar"),
              ),
            ],
          );
        },
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Lista de Productos',
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
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple, Colors.purple.shade300],
                  ),
                ),
              ),
            ),
          ),
          Consumer<ProductoControlador>(
            builder: (context, controlador, child) {
              final _productos = controlador.obtenerProductos();
              return _productos.isEmpty
                  ? SliverFillRemaining(
                child: Center(
                  child: Text(
                    "No hay productos guardados.",
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ),
              )
                  : SliverPadding(
                padding: EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final producto = _productos[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalleProductoVista(producto: producto),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.white, Colors.purple.shade50],
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(16),
                                    leading: Hero(
                                      tag: 'productImage${producto.rutaImagen}',
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: kIsWeb
                                              ? Image.network(
                                            producto.rutaImagen,
                                            fit: BoxFit.cover,
                                          )
                                              : Image.file(
                                            File(producto.rutaImagen),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      producto.nombre,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    subtitle: Text(
                                      producto.detalle,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Confirmar eliminación"),
                                              content: Text("¿Estás seguro de que quieres eliminar este producto?"),
                                              actions: [
                                                TextButton(
                                                  child: Text("Cancelar"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("Eliminar"),
                                                  onPressed: () {
                                                    Provider.of<ProductoControlador>(context, listen: false).eliminarProducto(producto);
                                                    Navigator.of(context).pop();
                                                    _mostrarMensaje("Producto eliminado de la Lista de Productos");
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _productos.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: agregarProducto,
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}