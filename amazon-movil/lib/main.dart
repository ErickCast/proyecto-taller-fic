
import 'package:amazon/providers/category_form_provider.dart';
import 'package:amazon/providers/providers.dart';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:amazon/src/pages/pages.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(AppState());
} 

class AppState extends StatelessWidget {
  


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ( _ ) => CategoriesProvider(), lazy: false,
        ),
        ChangeNotifierProvider(
          create: ( _ ) => ProductsProvider(), lazy: false,
        ),
        ChangeNotifierProvider(
          create: ( _ ) => SearchProvider(), lazy: false,
        ),
        ChangeNotifierProvider(
          create: ( _ ) => UiProvider(), lazy: false,
        ),
        ChangeNotifierProvider(
          create: ( _ ) => OrdersProvider(), lazy: false,
        )
        
      ],
      child: MyApp(),
    );
  }
}
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': ( _ ) => HomePage(),
        'productsByCategory': ( _ ) => ProductsByCategory(),
        'details': ( _ ) => ProductPage(),
        'login': ( _ ) => LoginPage(),
        'register': ( _ ) => RegisterPage(),
        'admin_category': ( _ ) => AdminCategoryPage(),
        'admin_product': ( _ ) => AdminProductPage(),
        'category_form': ( _ ) => CategoryScreen(),
        'product_form': ( _ ) => ProductFormPage(),
       },
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}