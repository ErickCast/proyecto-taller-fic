import 'package:amazon/models/product.dart';
import 'package:flutter/material.dart';

class ProductByCategorySlider extends StatefulWidget {

  final List<Producto> productos;
  const ProductByCategorySlider({
     Key? key,
     required this.productos
     }) : super(key: key);

  @override
  _ProductByCategorySliderState createState() => _ProductByCategorySliderState();
}

class _ProductByCategorySliderState extends State<ProductByCategorySlider> {

  final ScrollController scrollController = new ScrollController();

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
          )
          
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
            onTap: () {},
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
            )
        ],
      ),
    );
  }
}