
import 'package:amazon/providers/providers.dart';
import 'package:amazon/search/search_delegate.dart';
import 'package:amazon/src/pages/cart_page.dart';
import 'package:amazon/src/pages/profile_page.dart';
import 'package:amazon/src/pages/register_page.dart';
import 'package:amazon/widgets/custom_navigatorbar.dart';
import 'package:amazon/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {


  

  @override
  _HomePageState createState() => _HomePageState();
  
}
 

class _HomePageState extends State<HomePage> {

  String? displayName = "";

  @override
  void initState() {
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName');
    });
  }

  final LocalStorage storage = new LocalStorage('amazon');

  Map<String, dynamic>_usuario = {};
  String _nombreUsuario = "Sign In";

  Color myHexColor = Color(0xff0F1111);

  @override
  Widget build(BuildContext context) {

    
    // Navbar
    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/logo-amazon.png', fit: BoxFit.cover, width: 180,),
          
          backgroundColor: myHexColor
        ),
        body: _HomePageBody( context ),
        bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  Widget _homeBody() {
    final categoriesProvider = Provider.of<CategoriesProvider>(context, listen: true);

    final productosProvider = Provider.of<ProductsProvider>(context, listen: true);
  
    display(){
      if( displayName != null ) {
        return Text(displayName.toString(), style: GoogleFonts.asap(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),);
      }else{
        return Text('Iniciar sesion', style: GoogleFonts.asap( textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),);
      }
    }
    return Container(
          child: Column(
            children:[
              Row(
                
                children: [
                  _inputBusqueda(),
                  
                ],
                

              ),

              Container(                    
                height: 60.0,
                child: Expanded(
                  child: ListViewCategories(categorias: categoriesProvider.categorias)
                ),
              ),

              Container(
                child: Expanded(
                  child: Image(
                    image: AssetImage('assets/special-deal.jpg'),
                   
                  ),
                ),
              ),

              Container(                    
                height: 300.0,
                child: Expanded(
                  child: ProductSlider( 
                    productos: productosProvider.productos,
                    onNextPage: () => productosProvider.getProducts()
                  )
                )
              ),

              
            ]
          ),
        );
  }

  Widget _inputBusqueda(){
    return Expanded(
      child: TextField(
        //autofocus: true,
        onTap: () => {
          FocusScope.of(context).requestFocus(new FocusNode()),
          showSearch(context: context, delegate: MovieSearchDelegate())
          },
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0)
          ),
          
          hintText: 'Buscar Amazon',
          labelText: 'Buscar',
          suffixIcon: Icon( Icons.search )
        ),
      ),
    );
  }

  Widget _HomePageBody(context) {
  // Obtener el selected menu opt
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    //final tempScan = ScanModel( valor: 'http://google.com' );
    //DBProvider.db.nuevoScan(tempScan);
    //DBProvider.db.getScanById(id).then((scan) => print(scan.valor)) Obtener un registro por id


    switch(currentIndex) {

      case 0:
        return _homeBody();
      
      case 1:
        return ProfilePage();
      
      case 2:
        return CartPage();
      default:
        return Text('Holamundo');
    }
}
}


