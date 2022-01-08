import 'dart:convert';

import 'package:amazon/models/models.dart';
import 'package:amazon/providers/providers.dart';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AdminProductPage extends StatelessWidget {

  Color myHexColor = Color(0xff0F1111);
  
  @override
  Widget build(BuildContext context) {final productosProvider = Provider.of<ProductsProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/logo-amazon.png', fit: BoxFit.cover, width: 180,),
          
          backgroundColor: myHexColor
      ),
      body: Container(
        child: listadoProductos(context),
     ),
     floatingActionButton:  FloatingActionButton(
        child: Icon( Icons.add, color: Colors.black,),
        backgroundColor: Colors.yellow,
        onPressed: () {

          productosProvider.selectedProduct = Producto(id:"", nombre: "", usuario: "", precio: 0, categoria: "", descripcion: "", stock: 0);
          Navigator.pushNamed(context, 'product_form');
          
        },
      ),
   );
  }
}

Widget listadoProductos(BuildContext context) {
  final prefs = new PreferenciasUsuario();
  final productosProvider = Provider.of<ProductsProvider>(context, listen: true);
  List<Producto> productos = productosProvider.productos;
  var usuarioJson = (prefs.usuario != "") ? jsonDecode(prefs.usuario) : [];
  var user = jsonDecode(usuarioJson);
  if(user["usuario"]["rol"] == "VENTAS_ROLE"){
    productosProvider.getProductsByUser(user["usuario"]["uid"]);
    productos = productosProvider.productosByUser;
    
  }else{
    productos = productosProvider.productos;
  }
  


      

        return DataTable(
                
                sortColumnIndex: 2,
                sortAscending: false,
                columns: [
                  DataColumn(label: Text("id")),
                  DataColumn(label: Text("Nombre")),
                  DataColumn(label: Text("Acciones")),
                ],
                rows: List.generate(productos.length, (index) {
                  Producto producto = productos[index];
                  return DataRow(
                    selected: true,
                    cells: [
                    
                    DataCell(Text("${index+1}")),
                    DataCell(Text("${producto.nombre}")),
                    DataCell(
                      Row(
                        children: [
                          ElevatedButton(onPressed: (){
                            productosProvider.selectedProduct = Producto(
                              id: producto.id, 
                              nombre: producto.nombre,
                              usuario: producto.usuario,
                              precio: producto.precio,
                              categoria: producto.categoria,
                              promocion: 0,
                              descripcion: producto.descripcion,
                              stock: producto.stock
                            ); 

                            //productosProvider.selectedProduct = productosProvider.productos[index].copy();
                            print(productosProvider.selectedProduct.toJson());
                            Navigator.pushNamed(context, 'product_form');


                          }, child: Icon(Icons.edit, color: Colors.black,), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow.shade400), ),),
                          ElevatedButton(onPressed: () async{
                            await productosProvider.deleteProduct(producto);
                          }, child: Icon(Icons.delete, color: Colors.black), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red), ),)
                        ],
                      )
                      
                    )
                  ]);
                })
              );



  
  
}