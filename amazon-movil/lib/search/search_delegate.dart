import 'package:amazon/models/product.dart';
import 'package:amazon/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {

  @override
  String get searchFieldLabel => 'Buscar Producto';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon( Icons.clear),
        onPressed: () {
          query = '';
        },       
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null );
      }, 
      icon: Icon( Icons.arrow_back )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('BuildResults');
  }

  Widget _emptyContainer(){
    return Container(
      child: Center(
        child: Icon(Icons.shop, color: Colors.black38, size: 130,),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty) {
      return _emptyContainer();
    }

    final productosProvider = Provider.of<ProductsProvider>(context, listen: false);

    return FutureBuilder(
      future: productosProvider.searchProducts(query),
      builder: ( _, AsyncSnapshot<List<Producto>> snapshot ) {

        if( !snapshot.hasData ) return _emptyContainer();

        final productos = snapshot.data!;

        return ListView.builder(
          itemCount: productos.length,
          itemBuilder: ( _, int index ) => _ProductPoster(productos[index])
        );

      }
    );
  }
  

}

class _ProductPoster extends StatelessWidget {

  final Producto producto;


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
              tag: producto.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage('http://143.244.157.68:8080/api/productos/imagen/${producto.id}'),
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
                    producto.nombre,
                    maxLines: 2,
                    style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    
                    
                    ),
                ),
                Text("Precio: ${ producto.precio }", style: TextStyle(fontSize: 20.0),)
              ],
            ),
          
          
        ],
      ),
    );
  }
}