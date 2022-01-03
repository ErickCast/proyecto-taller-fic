import 'dart:convert';

import 'package:amazon/models/order.dart';
import 'package:amazon/providers/providers.dart';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:amazon/src/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class ProfilePage extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();

    

    
    
    return Container(
      child: (prefs.usuario == "") ? noUser(context) : withUser(context, prefs.usuario)
    );
  }

  

  
}

Widget withUser(BuildContext context, String usuario) {
  var usuarioJson = (usuario != "") ? jsonDecode(usuario) : [];
  var user = jsonDecode(usuarioJson);
  final uiProvider = Provider.of<UiProvider>(context);

  return ListView(
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    children: [
      Text('Hola ${ user["usuario"]["nombre"] }', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
      Divider(),
      (user["usuario"]["rol"] == "ADMIN_ROLE") ?
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton( onPressed: (){
            Navigator.push(context , MaterialPageRoute(builder: (context) => AdminCategoryPage()));
          }, child: Text('Administrar Categorias', style: TextStyle(color: Colors.black),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300), ),),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminProductPage()));
          }, child: Text('Administrar Productos', style: TextStyle(color: Colors.black)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300), ),)
        ],
      )
      :
      Container(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton( onPressed: (){}, child: Text('Mis pedidos', style: TextStyle(color: Colors.black),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300), ),),
          ElevatedButton(onPressed: (){}, child: Text('Comprar de nuevo', style: TextStyle(color: Colors.black)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300), ),)
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton( onPressed: (){}, child: Text('Mi cuenta', style: TextStyle(color: Colors.black),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300), ),),
          ElevatedButton(onPressed: (){}, child: Text('Wish List', style: TextStyle(color: Colors.black)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.shade300), ),)
        ],
      ),
      Divider(),
      Text('Mis pedidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      
      listadoPedidos(context, "Mexico", user["usuario"]["estado"], user["usuario"]["municipio"], user["usuario"]["uid"]),
      Divider(),
      Center(
        child: ElevatedButton(
          onPressed: () {
            final prefs = new PreferenciasUsuario();

            prefs.usuario = "";
            
            uiProvider.selectedMenuOpt = 0;
          }, 
          child: Text('Cerrar sesion', style: TextStyle(color: Colors.black)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),)
        ),
      )
    ],
  );
}

Widget listadoPedidos(BuildContext context, String pais, estado, municipio, idUsuario) {

  final ordenesProvider = Provider.of<OrdersProvider>(context, listen: true);

  return FutureBuilder(
      future: ordenesProvider.getOrdersByUserId(idUsuario),
      builder: (_, AsyncSnapshot<List<Orden>> snapshot){

        if( !snapshot.hasData ) {
          return Container(
            constraints: BoxConstraints( maxWidth: 150 ),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final List<Orden> ordenes = snapshot.data!;

        return DataTable(
                
                sortColumnIndex: 2,
                sortAscending: false,
                columns: [
                  DataColumn(label: Text("Envio a")),
                  DataColumn(label: Text("Costo")),
                  DataColumn(label: Text("Acciones")),
                ],
                rows: List.generate(ordenes.length, (index) {
                  Orden orden = ordenes[index];
                  return DataRow(
                    selected: true,
                    cells: [
                    DataCell(Text("${ orden.domicilio }, ${ orden.municipio }, ${ orden.estado } ")),
                    DataCell(Text("${orden.costo}")),
                    DataCell(ElevatedButton(onPressed: (){}, child: Text('Ver pedido', style: TextStyle(color: Colors.black)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow.shade400), ),))
                  ]);
                })
              );

      }
  );
  
  
}

Widget noUser(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 90.0),
      children: [
        
        
        Center(
          child: Text('Inicia sesion para obtener la mejor experiencia', style: TextStyle(fontSize: 30.0, ),),
        ),
        botonesAuth( context )
            
          
        
      ],
    );
  }

Widget botonesAuth( context ) {

    return Column(
      children: 
      [
        Center(
          child: ElevatedButton(
            child: Text('Iniciar sesion', style: TextStyle(color: Colors.black, fontSize: 20.0),),
            onPressed: () {
              Navigator.pushNamed(context , 'login');
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(500, 53),
              primary: Colors.yellow.shade600,
            ),
            
          )
        ),
        Center(
          child: ElevatedButton(
            child: Text('Crear cuenta', style: TextStyle(color: Colors.black, fontSize: 20.0),),
            onPressed: () {
              Navigator.pushNamed(context , 'register');
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(500, 53),
              primary: Colors.grey.shade400,
            ),
            
          )
        ),

      ]
    );

}

/* Widget layoutDown(){
  return Container(
    child: ListView.builder(
      itemCount: 3,
      scrollDirection: Axis.vertical,
      itemBuilder: ( BuildContext context, int index ) => _LayoutPoster()
    ),
  )
}
 */
