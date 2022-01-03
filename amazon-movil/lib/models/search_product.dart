// To parse this JSON data, do
//
//     final searchModel = searchModelFromMap(jsonString);

import 'dart:convert';

import 'package:amazon/models/product.dart';

class SearchProduct {
    SearchProduct({
        required this.results,
    });

    List<Producto> results;

    factory SearchProduct.fromJson(String str) => SearchProduct.fromMap(json.decode(str));

    factory SearchProduct.fromMap(Map<String, dynamic> json) => SearchProduct(
        results: List<Producto>.from(json["results"].map((x) => Producto.fromMap(x))),
    );

}

