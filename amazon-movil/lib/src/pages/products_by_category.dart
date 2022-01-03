import 'package:amazon/models/product.dart';
import 'package:amazon/providers/products_provider.dart';
import 'package:amazon/widgets/productByCategory_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsByCategory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productosProvider = Provider.of<ProductsProvider>(context, listen: true);

    final String id = ModalRoute.of(context)?.settings.arguments as String;
    return FutureBuilder(
      future: productosProvider.getProductsByCategory(id),
      builder: (_, AsyncSnapshot<List<Producto>> snapshot){

        if( !snapshot.hasData ) {
          return Container(
            constraints: BoxConstraints( maxWidth: 150 ),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final List<Producto> productos = snapshot.data!;

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
          body: Container(
            
            width: double.infinity,

            
            child: ListView.builder(
              itemCount: productos.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index ) => _ProductPoster(productos[index])
            ),
          ),
        );
      },
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