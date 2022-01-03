import 'dart:convert';

import 'dart:io';

import 'package:amazon/models/category.dart';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider extends ChangeNotifier {
  
  String _apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2MTY2N2Y4ODJiYjk1OGFkOGEwNDIyZDYiLCJpYXQiOjE2MzQ3OTcxMjIsImV4cCI6MTYzNTQwMTkyMn0.jRUanZ_0vnpBYW1CxJl4ZYHIm50MdFHIZvDfHNn823o';
  String _baseUrl = '143.244.157.68:8080/api/';

  List<Categoria> categorias = [];
  late Categoria selectedCategoria;

  final prefs = new PreferenciasUsuario();

  

  bool isSaving = false;

  CategoriesProvider() {
    print("Inicializando provider categories");

    this.getCategories();
  }

  getCategories() async {
    var url = Uri.parse('http://143.244.157.68:8080/api/categorias');

    final response = await http.get( url );
    final categoriasResponse = CategoriaResponse.fromJson(response.body);

    print( categoriasResponse.categorias );

    this.categorias = categoriasResponse.categorias;

    notifyListeners();
  }

  Future saveOrCreateCategory( Categoria category ) async{

    isSaving = true;
    notifyListeners();

    if( category.id == null ){
      // Crear nueva categoria
      await createCategory(category);
    }else{
      //Actualizar la categoria
      await UpdateCategory(category);
    }

    isSaving = false;
    notifyListeners();

  }

  Future<String> createCategory( Categoria category ) async {
    var url = Uri.parse('http://143.244.157.68:8080/api/categorias');

    var usuarioJson = (prefs.usuario != "") ? jsonDecode(prefs.usuario) : [];
    var user = jsonDecode(usuarioJson);

    final response = await http.post( url, headers: { 
      "content-type":"application/json; charset=UTF-8",
      'x-token': user["token"] 
      }, body: category.toJson() );
    final decodedData = json.decode(response.body);

    category.id = decodedData['categoriaGuardada']['_id'];
    print(category.id);

    this.categorias.add(category);
    

    return category.id!;
  } 

  Future<String> UpdateCategory( Categoria category ) async {
    var url = Uri.parse('http://143.244.157.68:8080/api/categorias/${category.id}');

    var usuarioJson = (prefs.usuario != "") ? jsonDecode(prefs.usuario) : [];
    var user = jsonDecode(usuarioJson);

    final response = await http.put( url,  headers: { 
      "content-type":"application/json; charset=UTF-8",
      'x-token': user["token"] 
      }, body: category.toJson() );
    //final decodedData = json.decode(response.body);

    final index = this.categorias.indexWhere((element) => element.id == category.id);

    this.categorias[index] = category;

    return category.id!;
  } 

  deleteCategory( Categoria category ) async{
    var url = Uri.parse('http://143.244.157.68:8080/api/categorias/${category.id}');

    var usuarioJson = (prefs.usuario != "") ? jsonDecode(prefs.usuario) : [];
    var user = jsonDecode(usuarioJson);

    final response = await http.delete( url, headers: { 
      "content-type":"application/json; charset=UTF-8",
      'x-token': user["token"] 
      }, );

      final index = this.categorias.removeWhere((element) => element.id == category.id);
  }
}