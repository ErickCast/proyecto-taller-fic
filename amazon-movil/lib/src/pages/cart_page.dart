import 'dart:convert';

import 'package:amazon/models/models.dart';
import 'package:amazon/providers/providers.dart';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:amazon/src/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class CartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    final uiProvider = Provider.of<UiProvider>(context);
    List<dynamic> productos = (prefs.carrito != "") ? jsonDecode(prefs.carrito) : [];
    print(productos);
    productos.forEach((producto) {
      Container(
      child: Text("Nombre ${ producto['nombre'] }"),
      );
    });

    return Container(
        
        child: Column(
          children: 
          [
            Text('Carrito de compras', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
            
            Expanded(
              child: (productos.length == 0) ? Center(child: Text("No hay productos en el carrito", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)) : ListView.builder(
                itemCount: productos.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index ) => _ProductPoster(productos[index])
              ),
            ),
            Row(
              children: [
                (prefs.carrito == "") ? Text("") :
                ElevatedButton(
                  onPressed: () {
                    final prefs = new PreferenciasUsuario();

                    prefs.carrito = "";
                    
                    uiProvider.selectedMenuOpt = 0;
                  }, 
                  child: Text('Vaciar carrito', style: TextStyle(color: Colors.black)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),)
                ),
                (prefs.carrito == "") ? Text("") :
                ElevatedButton(
                  onPressed: () {
                    final prefs = new PreferenciasUsuario();

                    if(prefs.usuario == ""){
                      _mostrarAlertNoUser(context);
                    }else{
                      generarOrden(context, prefs.usuario, prefs.carrito);

                      prefs.carrito = "";

                      uiProvider.selectedMenuOpt = 1;
                    }

                    

                    
                  }, 
                  child: Text('Finalizar pedido', style: TextStyle(color: Colors.black)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow.shade400)) 
                )
              ],
            )
          ]
        ),
    );
    
    
  }

  void generarOrden(BuildContext context, String usuario, String carrito) async {

    var usuarioList = jsonDecode(usuario);
    var usuarioList2 = jsonDecode(usuarioList);
    var sumaCosto = 0.0;
    List<dynamic> carritoList = jsonDecode(carrito);

    //var cartBody = "[ \r\n        {\r\n            "nombre" : "Celular samsung",\r\n            "precio" : 3650,\r\n            "promocion" : 0,\r\n            "descripcion" : "loremi ipsum dolor sit amet",\r\n            "stock" : 3,\r\n            "imagen" : "4cb88a64-10ca-405b-a56a-beea0683c943.jpg"\r\n        }\r\n    ]";
    var cartBody = "[ \r\n        ";
    int i = 1;
    carritoList.forEach((producto) { 
      if( i == carritoList.length){
        //cartBody += '{\r\n            "nombre" : "${producto["nombre"]}",\r\n            "precio" : ${producto["precio"]},\r\n            "promocion" : ${producto["promocion"]},\r\n            "descripcion" : "${producto["descripcion"]}",\r\n            "stock" : ${producto["stock"]},\r\n            "imagen" : "${producto["imagen"]}"\r\n        }';
        cartBody += '{\r\n            "_id" : "${producto["_id"]}",\r\n            "nombre" : "${producto["nombre"]}",\r\n            "precio" : ${producto["precio"]},\r\n            "promocion" : ${producto["promocion"]},\r\n            "stock" : ${producto["stock"]},\r\n            "imagen" : "${producto["imagen"]}"\r\n        }';
      }else{  
        //cartBody += '{\r\n            "nombre" : "${producto["nombre"]}",\r\n            "precio" : ${producto["precio"]},\r\n            "promocion" : ${producto["promocion"]},\r\n            "descripcion" : "${producto["descripcion"]}",\r\n            "stock" : ${producto["stock"]},\r\n            "imagen" : "${producto["imagen"]}"\r\n        },';
        cartBody += '{\r\n            "_id" : "${producto["_id"]}",\r\n            "nombre" : "${producto["nombre"]}",\r\n            "precio" : ${producto["precio"]},\r\n            "promocion" : ${producto["promocion"]},\r\n            "stock" : ${producto["stock"]},\r\n            "imagen" : "${producto["imagen"]}"\r\n        },';
        i++;
      }
      sumaCosto += producto["precio"];
      
      
    });
    cartBody += "\r\n    ]";

    var headers = {
      'x-token': '${ usuarioList2["token"] }',
      "content-type":"application/json; charset=UTF-8"
    };
    var request = http.Request('POST', Uri.parse('http://143.244.157.68:8080/api/ordenes'));
    request.body = '''{\r\n    "pais" : "${ usuarioList2["usuario"]["pais"] }",\r\n    "estado" : "${ usuarioList2["usuario"]["estado"] }",\r\n    "municipio" : "${ usuarioList2["usuario"]["municipio"] }",\r\n    "domicilio" : "${ usuarioList2["usuario"]["domicilio"] }",\r\n    "costo" : $sumaCosto,\r\n    "productos" : $cartBody\r\n}''';
    //var body = '''{\r\n    "pais" : "${ usuarioList2["usuario"]["pais"] }",\r\n    "estado" : "${ usuarioList2["usuario"]["estado"] }",\r\n    "municipio" : "${ usuarioList2["usuario"]["municipio"] }",\r\n    "domicilio" : "${ usuarioList2["usuario"]["domicilio"] }",\r\n    "costo" : 3650.00,\r\n    "productos" : [ \r\n        {\r\n            "nombre" : "Celular samsung",\r\n            "precio" : 3650,\r\n            "promocion" : 0,\r\n            "descripcion" : "loremi ipsum dolor sit amet",\r\n            "stock" : 3,\r\n            "imagen" : "4cb88a64-10ca-405b-a56a-beea0683c943.jpg"\r\n        }\r\n    ]\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    /* final response = await http.post(Uri.parse('http://10.0.2.2:8080/api/ordenes'), headers: {
    "content-type":"application/json; charset=UTF-8",
    'x-token': '${ usuarioList2["token"] }'
    }, body: body); */

    if(response.statusCode == 200){
      print(await response.stream.bytesToString());
      
    }else{
      print("No se pudo realizar la orden");
    }
    
    
  }

  void _mostrarAlertNoUser(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context)  {

        

        return AlertDialog(
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
              title: Text("No iniciaste sesion"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  
                  Text("Para realizar un pedido, primero debes iniciar sesion con tu cuenta")
                  
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Ir al login'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                ),
              ],
            );

          }
        );
  }
}

class _ProductPoster extends StatelessWidget {

  final producto;


  const _ProductPoster( this.producto );

  Widget build(BuildContext context) {

  final size = MediaQuery.of(context).size;
   

    return Container(
      
      width: 130,
      height: 190,
      margin: EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: producto),
            child: Hero(
              tag: producto['_id'],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage('http://143.244.157.68:8080/api/productos/imagen/${producto['_id']}'),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
              
                ),
              ),
            ),
          ), 

          SizedBox( height: 5, ),

          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints( maxWidth: size.width - 190 ),
                  child: Text(
                    producto['nombre'],
                    maxLines: 2,
                    style: TextStyle( fontSize: 18 ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    
                    
                    ),
                ),
                Text("Precio: ${ producto['precio'] }", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                if(producto['stock'] != 0) Text('Disponible', style: TextStyle(color: Colors.green, fontSize: 20.0),)
              ],
            ),
          
          
        ],
      ),
    );
  }
}

