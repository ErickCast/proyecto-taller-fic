import 'dart:convert';

import 'package:amazon/models/product.dart';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
  
    final Producto producto = ModalRoute.of(context)?.settings.arguments as Producto;

    
    

    final prefs = new PreferenciasUsuario();
    

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo-amazon.png', fit: BoxFit.cover, width: 180,),
        actions: <Widget>[

          Container(
            
            child: Column(
              children: [
                Row(
                  children: [
                    

                    TextButton(
                      child: Row(
                      children: [
                        Icon(Icons.shopping_cart),
                        Text('(0)')
                      ],
                    ),
                      style: TextButton.styleFrom(primary: Colors.white),
                      onPressed: () {},
                    ),

                    
                  ],
                ),

                
              ],
          
            ),
          ),

          

          
          
          

        ],
        backgroundColor: Colors.black
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Container(
            margin: EdgeInsets.only(top: 20, right: 35, left: 35),
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${producto.nombre}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                Hero(
                  tag: producto.id,
                  child: Image(
                    width: 200,
                    //alignment: Alignment.topCenter,
                    image: NetworkImage('http://143.244.157.68:8080/api/productos/imagen/${producto.id}'),
                    
                  ),
                ),
                
                Text("Precio: ${producto.precio}", style: TextStyle(fontSize: 18.0)),
                Text("Hasta 12 meses sin intereses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                _disponible( producto.stock ),
                Text("${ producto.descripcion }", style: TextStyle(fontSize: 18.0)),
                _stock(producto.stock),
                _botonCarrito(producto)
                
              
              ],
            ),
          ),
        ),
      ),
    );
  }

  _disponible(int stock) {
    if( stock > 0) {
      return Text("Disponible", style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold ),);
    }else{
      return Text("No disponible", style: TextStyle(color: Colors.red, fontSize: 24,  fontWeight: FontWeight.bold ),);
    }
  }

  _stock(int stock) {
    if( stock > 0) {
      return Text("Stock: $stock", style: TextStyle(fontSize: 18.0));
    }else{
      return Container();
    }
  }

  _botonCarrito(Producto producto) {
    final prefs = new PreferenciasUsuario();
    List<dynamic> productos = [];
    bool band = false;
    if( producto.stock > 0){
      return ElevatedButton(
        child: Text('Agregar al carrito', style: TextStyle(color: Colors.black, fontSize: 20.0),),
        onPressed: () {
          if(prefs.carrito == ""){
            productos.add(producto.toMap());
            prefs.carrito = jsonEncode(productos);
            
          }else{
            productos = jsonDecode(prefs.carrito);
            productos.forEach((productoList) { 
              if(productoList['_id'] != producto.toMap()['_id']){
                print('el producto es diferente');
                band = true;
                
              }else{
                print('el producto es igual');
                band = false;
                
              }
            });
            if(band){
              productos.add(producto.toMap());
              prefs.carrito = jsonEncode(productos);
            }
            
            print(productos);
            
            
            
            
            
          }
          

        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(200, 53),
          primary: Colors.yellow.shade600,
        ),
        
      );
    }else {
      return Container();
    }
    
  }
}