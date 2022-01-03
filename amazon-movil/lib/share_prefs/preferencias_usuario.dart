import 'dart:convert';

import 'package:amazon/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del Genero
  int get genero {
    return _prefs.getInt('genero') ?? 1;
  }

  set genero( int value ) {
    _prefs.setInt('genero', value);
  }

  // GET y SET del carrito de compras
  String get carrito {
    return _prefs.getString('carrito') ?? '';
  }

  set carrito( String producto ) {
    _prefs.setString('carrito', producto);
  }

  // GET y SET del usuario
  String get usuario {
    return _prefs.getString('usuario') ?? '';
  }

  set usuario(String data ) {
    _prefs.setString('usuario', data);
  }

  // GET y SET del token del usuario
  String get tokenUser {
    return _prefs.getString('tokenUser') ?? '';
  }

  set tokenUser(String data ) {
    _prefs.setString('tokenUser', data);
  }



}