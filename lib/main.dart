import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vista/home_screen.dart';
import 'controlador/producto_controlador.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductoControlador(),
      child: MaterialApp(
        title: 'Registro de Productos',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PantallaPrincipal(),
      ),
    );
  }
}