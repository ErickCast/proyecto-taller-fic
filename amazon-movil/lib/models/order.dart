// To parse this JSON data, do
//
//     final orderModel = orderModelFromMap(jsonString);

import 'dart:convert';

class OrderModel {
    OrderModel({
        required this.ordenes,
    });

    List<Orden> ordenes;

    factory OrderModel.fromJson(String str) => OrderModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        ordenes: List<Orden>.from(json["ordenes"].map((x) => Orden.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "ordenes": List<dynamic>.from(ordenes.map((x) => x.toMap())),
    };
}

class Orden {
    Orden({
        required this.id,
        required this.pais,
        required this.estado,
        required this.municipio,
        required this.domicilio,
        required this.costo,
        required this.productos,
        required this.usuario,
    });

    String id;
    String pais;
    String estado;
    String municipio;
    String domicilio;
    var costo;
    List<Producto> productos;
    String usuario;

    factory Orden.fromJson(String str) => Orden.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Orden.fromMap(Map<String, dynamic> json) => Orden(
        id: json["_id"],
        pais: json["pais"],
        estado: json["estado"],
        municipio: json["municipio"],
        domicilio: json["domicilio"],
        costo: json["costo"],
        productos: List<Producto>.from(json["productos"].map((x) => Producto.fromMap(x))),
        usuario: json["usuario"]
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "pais": pais,
        "estado": estado,
        "municipio": municipio,
        "domicilio": domicilio,
        "costo": costo,
        "productos": List<dynamic>.from(productos.map((x) => x.toMap())),
        "usuario": usuario
    };
}

class Producto {
    Producto({
        required this.id,
        required this.nombre,
        required this.precio,
        required this.promocion,
        required this.stock,
        required this.imagen,
    });

    String? id;
    String nombre;
    var precio;
    int promocion;
    int stock;
    String imagen;

    factory Producto.fromJson(String str) => Producto.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Producto.fromMap(Map<String, dynamic> json) => Producto(
        id: json["_id"],
        nombre: json["nombre"],
        precio: json["precio"],
        promocion: json["promocion"],
        stock: json["stock"],
        imagen: json["imagen"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
        "precio": precio,
        "promocion": promocion,
        "stock": stock,
        "imagen": imagen,
    };
}

