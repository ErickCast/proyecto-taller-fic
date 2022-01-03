import 'package:amazon/models/category.dart';
import 'package:amazon/src/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ListViewCategories extends StatelessWidget {

  final List<Categoria> categorias;
  

  const ListViewCategories({
    Key? key,
    required this.categorias
  }) : super( key: key );

  

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    if( this.categorias.length == 0 ) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          child: CircularProgressIndicator()
          ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: categorias.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: ( _ ,int index ){

        final categoria = categorias[index];

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'productsByCategory', arguments: categoria.id),
          child: Container(
            width: 100.0,
            child: Center(child: Text(categoria.nombre, textAlign: TextAlign.center, style: GoogleFonts.asap(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,)))),
            color: Colors.black,
          ),
        );

      }
    );
  }
}