import 'package:amazon/providers/categories_provider.dart';
import 'package:amazon/providers/product_form_provider.dart';
import 'package:amazon/providers/products_provider.dart';
import 'package:amazon/ui/input_decorations.dart';
import 'package:amazon/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return ChangeNotifierProvider(
      create: ( _ ) =>  ProductFormProvider( productsProvider.selectedProduct ),
      child:  _ProductFormBody(productsProvider: productsProvider,),
    );
  }
}

class _ProductFormBody extends StatelessWidget {

  _ProductFormBody({
    Key? key,
    required this.productsProvider,
  }) : super(key: key);

  final ProductsProvider productsProvider;
  
  Color myHexColor = Color(0xff0F1111);
  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Agregar producto'),
        backgroundColor: myHexColor
      ),

      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            
            Stack(
              children: [
                ProductImage( url: productsProvider.selectedProduct.imagen ),
                //Image.network("http://10.0.2.2:8080/api/productos/imagen/${ productsProvider.selectedProduct.id }", opacity: 0.5,),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white, ),
                  )
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async{
                      // Usar la camara
                      final selection = await OptionImagePicker(context);
                      if(selection == null) return;
                      final picker = new ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: (selection == 1)
                            ? ImageSource.camera
                            : ImageSource.gallery,
                        imageQuality: 100
                      );

                      if( pickedFile == null ){
                        
                        return;
                      }

                      
                      productsProvider.updateSelectedProductImage(pickedFile.path);
                      productForm.product.imagen = pickedFile.path;
                    },
                    icon: Icon(Icons.camera_alt_outlined,
                     size: 40, color: Colors.white, ),
                  )
                )
              ],
            ),

            _ProductForm(),

            SizedBox( height: 100, )
            
          ],
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.save_outlined ),
        onPressed: () async{
          if ( !productForm.isValidForm()) return;

          await productsProvider.saveOrCreateProduct(productForm.product);
          print(productForm.product.toJson());
          print(productsProvider.selectedProduct.imagen);

          Navigator.pop(context);
        
        },
      ),
    );
  }
}


class _ProductForm extends StatefulWidget {

  

  @override
  State<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<_ProductForm> {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    final productsProvider = Provider.of<ProductsProvider>(context);
    final categoriasProvider = Provider.of<CategoriesProvider>(context);
    String opcionSeleccionada = (product.categoria == "") ? '0' : product.categoria;

    List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [
      DropdownMenuItem(
        child: Text('Elige la categoria'),
        value: "0",
      )
    ];

    categoriasProvider.categorias.forEach((categoria) {

      lista.add(DropdownMenuItem(
        child: Text(categoria.nombre),
        value: categoria.id,
      ));

     });

     return lista;
  }
    
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 10 ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 580,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10,),

              TextFormField(
                initialValue: product.nombre,
                onChanged: ( value ) => product.nombre = value,
                validator: (value) {
                  if(value == null || value.length < 1)
                    return 'El nombre es obligatorio'; 
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre:'
                ),
              ),

              SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.category),
                  SizedBox(width: 30.0,),

                  Expanded(
                    child: DropdownButton(
                    value: opcionSeleccionada,
                    items: getOpcionesDropdown(),
                    onChanged: (opt) {
                      setState(() {
                        
                        opcionSeleccionada = opt.toString();
                        product.categoria = opcionSeleccionada;
                        print(opcionSeleccionada);
                      });
                    },
                      ),
                  )

                ],
              ),

              SizedBox(height: 30,),

              TextFormField(
                initialValue: product.precio.toString(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: ( value ) {
                  if ( double.tryParse(value) == null ) {
                    product.precio = 0;
                  } else {
                    product.precio = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio:'
                ),
              ),

              SizedBox(height: 30,),
              
              TextFormField(
                initialValue: product.stock.toString(),
                
                onChanged: ( value ) {
                  if ( double.tryParse(value) == null ) {
                    product.stock = 0;
                  } else {
                    product.stock = int.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Ingrese el stock',
                  labelText: 'Stock:'
                ),
              ),
              SizedBox(height: 30,),
              TextFormField(
                initialValue: product.descripcion,
                maxLines: 8,
                onChanged: ( value ){
                  product.descripcion = value;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Descripcion del producto',
                  labelText: 'Descripcion:'
                ),
              ),

              

            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only( bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25) ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]
  );
}

dynamic OptionImagePicker(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        title: Text('Seleccione una imagen o tome una fotografía'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                
                children: [
                  Column(
                    children: [
                      Icon(Icons.camera_alt, size: 50, color: Colors.indigo),
                      
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.storage, size: 50, color: Colors.indigo),
                      
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cámara',
                style: TextStyle(fontSize: 17, color: Colors.indigo)),
            onPressed: () {
              Navigator.of(context).pop(1);
            },
          ),
          TextButton(
            child: const Text('Galería',
                style: TextStyle(fontSize: 17, color: Colors.indigo)),
            onPressed: () {
              Navigator.of(context).pop(2);
            },
          ),
          TextButton(
            child: Icon(Icons.close_rounded, color: Colors.red, size: 40),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}