import 'package:amazon/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {

  String _baseUrl = '143.244.157.68:8080/api/';

  List<Producto> productos = [];

  SearchProvider() {
    print("Inicializando provider search");

    this.getProducts();
  }

  getProducts() async {
    var url = Uri.parse('http://143.244.157.68:8080/api/productos');

    final response = await http.get( url );
    final productosResponse = ProductoResponse.fromJson(response.body);

    print( productosResponse.productos );

    this.productos = productosResponse.productos;

    notifyListeners();
  }

}