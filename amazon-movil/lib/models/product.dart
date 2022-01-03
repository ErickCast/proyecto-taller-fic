// To parse this JSON data, do
//
//     final productoResponse = productoResponseFromMap(jsonString);

import 'dart:convert';

class ProductoResponse {
    ProductoResponse({
        required this.productos,
    });

    List<Producto> productos;

    factory ProductoResponse.fromJson(String str) => ProductoResponse.fromMap(json.decode(str));



    factory ProductoResponse.fromMap(Map<String, dynamic> json) => ProductoResponse(
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromMap(x))),
    );

}

class Producto {
    Producto({
        required this.id,
        required this.nombre,
        required this.usuario,
        required this.precio,
        required this.categoria,
        this.promocion,
        required this.descripcion,
        required this.stock,
        this.imagen,
    });

    String id;
    String nombre;
    String usuario;
    double precio;
    String categoria;
    int? promocion;
    String descripcion;
    int stock;
    String? imagen;

    factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());


    factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        id: json["_id"],
        nombre: json["nombre"],
        usuario: json["usuario"],
        precio: json["precio"].toDouble(),
        categoria: json["categoria"],
        promocion: json["promocion"],
        descripcion: json["descripcion"],
        stock: json["stock"],
        imagen: json["imagen"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
        "usuario": usuario,
        "precio": precio,
        "categoria": categoria,
        "promocion": promocion,
        "descripcion": descripcion,
        "stock": stock,
        "imagen": imagen,
    };

    Producto copy() => Producto(
      id: this.id,
      nombre: this.nombre,
      usuario: this.usuario,
      precio: this.precio,
      categoria: this.categoria,
      promocion: this.promocion,
      descripcion: this.descripcion,
      stock: this.stock,
      imagen: this.imagen,
    );

    

}


