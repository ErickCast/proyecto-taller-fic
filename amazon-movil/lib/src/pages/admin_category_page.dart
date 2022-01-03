import 'package:amazon/models/category.dart';
import 'package:amazon/models/models.dart';
import 'package:amazon/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AdminCategoryPage extends StatelessWidget {

Color myHexColor = Color(0xff0F1111);
  @override
  Widget build(BuildContext context) {

    final categoriesProvider = Provider.of<CategoriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/logo-amazon.png', fit: BoxFit.cover, width: 180,),
          
          backgroundColor: myHexColor
      ),
      body: Container(
        child: listadoCategorias(),
     ),
     floatingActionButton:  FloatingActionButton(
        child: Icon( Icons.add, color: Colors.black,),
        backgroundColor: Colors.yellow,
        onPressed: () {
          
          categoriesProvider.selectedCategoria = Categoria(nombre: '');

          Navigator.pushNamed(context, 'category_form');
          
        },
      ),
   );
  }
}
class listadoCategorias extends StatefulWidget {
  listadoCategorias({Key? key}) : super(key: key);

  @override
  _listadoCategoriasState createState() => _listadoCategoriasState();
}

class _listadoCategoriasState extends State<listadoCategorias> {
  @override
  Widget build(BuildContext context) {
    final categoriasProvider = Provider.of<CategoriesProvider>(context, listen: true);
  List<Categoria> categorias = categoriasProvider.categorias;


      

        return DataTable(
                
                sortColumnIndex: 2,
                sortAscending: false,
                columns: [
                  DataColumn(label: Text("id")),
                  DataColumn(label: Text("Nombre")),
                  DataColumn(label: Text("Acciones")),
                ],
                rows: List.generate(categorias.length, (index) {
                  Categoria categoria = categorias[index];
                  return DataRow(
                    selected: true,
                    cells: [
                    
                    DataCell(Text("${index+1}")),
                    DataCell(Text("${categoria.nombre}")),
                    DataCell(
                      Row(
                        children: [
                          ElevatedButton(onPressed: (){
                            categoriasProvider.selectedCategoria = Categoria(id: categoria.id, nombre: categoria.nombre);
                            
                            Navigator.pushNamed(context, 'category_form');
                          }, child: Icon(Icons.edit, color: Colors.black,), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow.shade400), ),),
                          ElevatedButton(onPressed: (){
                            setState(() {
                              categoriasProvider.deleteCategory(categoria);
                            });
                            

                          }, child: Icon(Icons.delete, color: Colors.black), style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red), ),)
                        ],
                      )
                      
                    )
                  ]);
                })
              );
  }
}

