import 'dart:convert';

import 'package:amazon/providers/providers.dart';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final uiProvider = Provider.of<UiProvider>(context);

    final currentIndex = uiProvider.selectedMenuOpt;
    final prefs = new PreferenciasUsuario();

    List<dynamic> productos = (prefs.carrito != "") ? jsonDecode(prefs.carrito) : [];
    

    // Cuando se tienen 4 o mas elementos hay que agregar esta linea: type: BottomNavigationBarType.fixed
    return BottomNavigationBar(
      onTap: ( int i ) => uiProvider.selectedMenuOpt = i,
      backgroundColor: Colors.black12,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: ""
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          label: ""
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "${ productos.length.toString() }"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: ""
        ),
      ],
      
    );
  }
}