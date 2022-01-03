// To parse this JSON data, do
//
//     final categoriaResponse = categoriaResponseFromMap(jsonString);

import 'dart:convert';

class CategoriaResponse {
    CategoriaResponse({
        required this.categorias,
    });

    List<Categoria> categorias;

    factory CategoriaResponse.fromJson(String str) => CategoriaResponse.fromMap(json.decode(str));

     String toJson() => json.encode(toMap());

    factory CategoriaResponse.fromMap(Map<String, dynamic> json) => CategoriaResponse(
        categorias: List<Categoria>.from(json["categorias"].map((x) => Categoria.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "categorias": List<dynamic>.from(categorias.map((x) => x.toMap())),
    };

   
}

class Categoria {
    Categoria({
        this.id,
        required this.nombre,
        this.v,
    });

    String? id;
    String nombre;
    int? v;

    factory Categoria.fromJson(String str) => Categoria.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Categoria.fromMap(Map<String, dynamic> json) => Categoria(
        id: json["_id"],
        nombre: json["nombre"],
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
        "__v": v,
    };

}
