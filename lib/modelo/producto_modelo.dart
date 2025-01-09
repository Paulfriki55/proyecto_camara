class Producto {
  final String rutaImagen;
  final String nombre;
  final String detalle;

  Producto({
    required this.rutaImagen,
    required this.nombre,
    required this.detalle,
  });

  Map<String, dynamic> toJson() {
    return {
      'rutaImagen': rutaImagen,
      'nombre': nombre,
      'detalle': detalle,
    };
  }

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      rutaImagen: json['rutaImagen'],
      nombre: json['nombre'],
      detalle: json['detalle'],
    );
  }
}