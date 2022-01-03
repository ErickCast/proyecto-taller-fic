import 'dart:convert';
import 'dart:io';

import 'package:amazon/models/product.dart';
import 'package:amazon/models/search_product.dart';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductsProvider extends ChangeNotifier {
  
  String _apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2MTY2N2Y4ODJiYjk1OGFkOGEwNDIyZDYiLCJpYXQiOjE2MzQ3OTcxMjIsImV4cCI6MTYzNTQwMTkyMn0.jRUanZ_0vnpBYW1CxJl4ZYHIm50MdFHIZvDfHNn823o';
  String _baseUrl = 'http://143.244.157.68:8080/api/';

  List<Producto> productos = [];
  late Producto selectedProduct;
  bool isSaving = false;

  final prefs = new PreferenciasUsuario();

  File? newPictureFile;

  ProductsProvider() {
    print("Inicializando provider productos");

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

   Future<List<Producto>> getProductsByCategory(id) async {
    var url = Uri.parse('http://143.244.157.68:8080/api/productos/getProductosByCategoria/$id');

    final response = await http.get( url );
    final productosResponse = ProductoResponse.fromJson(response.body);

    return productosResponse.productos;

  }

  Future<List<Producto>> searchProducts( String query ) async {
    final url = Uri.parse('http://143.244.157.68:8080/api/buscar/productos/$query');

    final response = await http.get(url);
    final searchProducts = SearchProduct.fromJson(response.body);

    return searchProducts.results;
  }

  Future saveOrCreateProduct( Producto product ) async {

    isSaving = true;
    notifyListeners();

    if( product.id == "" ) {
      // Es crear
      await this.createProduct(product);
    }else{
      await this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();

  }

  Future<String> updateProduct( Producto product ) async {
    final url = Uri.parse('http://143.244.157.68:8080/api/productos/${product.id}');
    var usuarioJson = (prefs.usuario != "") ? jsonDecode(prefs.usuario) : [];
    var user = jsonDecode(usuarioJson);

    var headers = {
      "content-type":"application/json; charset=UTF-8",
      'x-token': user["token"].toString()
    };
    var request = http.MultipartRequest('PUT', url);
    //request.body = '''\r\n{\r\n    "nombre":"${product.nombre}",\r\n    "precio": ${product.precio},\r\n    "categoria": "${product.categoria}",\r\n    "promocion": 0,\r\n    "descripcion":"${ product.descripcion }",\r\n    "stock": ${ product.stock },\r\n    "imagen":"${ product.imagen }"\r\n}\r\n''';
    request.fields.addAll({
      'nombre': product.nombre,
      'precio': product.precio.toString(),
      'categoria': product.categoria,
      'promocion': "0",
      'descripcion': product.descripcion,
      'stock': product.stock.toString()
    }); 
    

    request.files.add(await http.MultipartFile.fromPath('img', product.imagen!));
    request.headers.addAll(headers);
    print(product.imagen);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("Se actualizo");
    }
    else {
      print(response.reasonPhrase);
      print("No se actualizo");
    }
    /* final resp = await http.put(url, headers: { 
      "content-type":"application/json; charset=UTF-8",
      'x-token': user["token"] 
      }, body: product.toJson() );
    final decodedData = resp.body; */

    

    // Actualizando el listado de productos
    /* products.forEach((element) { 
      if(element.id == product.id){
        element = product;
        notifyListeners();
      }
      
    }); */
    final index = this.productos.indexWhere((element) => element.id == product.id);
    //this.productos[index] = product;
    this.getProducts();

    return product.id;
  }

  Future<String> createProduct( Producto product ) async {
    final url = Uri.parse('http://143.244.157.68:8080/api/productos/');
    var producto = jsonDecode(product.toJson());
    print(producto);
    var usuarioJson = (prefs.usuario != "") ? jsonDecode(prefs.usuario) : [];
    var user = jsonDecode(usuarioJson);
    var headers = {
      "content-type":"application/json; charset=UTF-8",
      'x-token': user["token"].toString()
    };
    final resp = await http.MultipartRequest('POST', url);
    resp.fields.addAll({
      'nombre': producto["nombre"],
      'precio': producto["precio"].toString(),
      'categoria': producto["categoria"],
      'promocion': "0",
      'descripcion': producto["descripcion"],
      'stock': producto["stock"].toString()
    }); 
    resp.files.add(await http.MultipartFile.fromPath('img', producto["imagen"]));
    resp.headers.addAll(headers);
    http.StreamedResponse response = await resp.send();
    
    /* final decodedData = json.decode(resp.body);
    print(decodedData); 

    product.id = decodedData['producto']['nombre']; */

    

    
    final index = this.productos.indexWhere((element) => element.id == product.id);
    
    //this.productos.add(product);
    this.getProducts();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print("se guardo");
    }
    else {
      print(response.reasonPhrase);
      print("no se guardo");
    }
    

    

    return product.id;
  }

  void updateSelectedProductImage( String path ) {

    this.selectedProduct.imagen = path;
    this.newPictureFile = File.fromUri( Uri(path: path) );

    notifyListeners();
  }

  deleteProduct( Producto product ) async{
    var url = Uri.parse('http://143.244.157.68:8080/api/productos/${product.id}');

    var usuarioJson = (prefs.usuario != "") ? jsonDecode(prefs.usuario) : [];
    var user = jsonDecode(usuarioJson);

    final response = await http.delete( url, headers: { 
      "content-type":"application/json; charset=UTF-8",
      'x-token': user["token"] 
      }, );

      final index = this.productos.removeWhere((element) => element.id == product.id);
  }

}