import 'package:amazon/models/product.dart';
import 'package:flutter/material.dart';

class ProductSlider extends StatefulWidget {
  
  final List<Producto> productos;
  final Function onNextPage;
  
  const ProductSlider({ 
    Key? key,
    required this.productos,
    required this.onNextPage, 
  }) : super(key: key);

  @override
  _ProductSliderState createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {

  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() { 

      if( scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500 ){
        widget.onNextPage();
      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    if( this.widget.productos.length == 0 ) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(child: CircularProgressIndicator(),),
      );
    }

    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
            Padding(
              padding: EdgeInsets.symmetric( horizontal: 20 ),
              child: Text("Productos", style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold),),  
          ),
          

          SizedBox( height: 5 ),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: this.widget.productos.length,
              itemBuilder: ( _, int index) => _ProductPoster( widget.productos[index])
            ),
          ),
          
          
        ],
      ),
    );
  }
}

class _ProductPoster extends StatelessWidget {

  final Producto producto;


  const _ProductPoster( this.producto );

  Widget build(BuildContext context) {

   

    return Container(
      width: 130,
      height: 190,
      margin: EdgeInsets.symmetric( horizontal: 10 ),
      child: Column(
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

          Text(
            producto.nombre,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            ),
            Text("Precio: ${ producto.precio }", style: TextStyle(fontSize: 18.0),)
        ],
      ),
    );
  }
}