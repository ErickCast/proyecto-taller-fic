import 'package:amazon/providers/categories_provider.dart';
import 'package:amazon/providers/category_form_provider.dart';
import 'package:amazon/ui/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final categoryProvider = Provider.of<CategoriesProvider>(context);

    return ChangeNotifierProvider(
      create: ( _ ) =>  CategoryFormProvider( categoryProvider.selectedCategoria ),
      child:  _CategoryFormBody(categoryProvider: categoryProvider,),
    );

    //return _ProductScreenBody(productService: productService);
  }
}

class _CategoryFormBody extends StatelessWidget {

  _CategoryFormBody({
    Key? key,
    required this.categoryProvider,
  }) : super(key: key);

  final CategoriesProvider categoryProvider;
  
  Color myHexColor = Color(0xff0F1111);
  @override
  Widget build(BuildContext context) {

    final categoryForm = Provider.of<CategoryFormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar categoria'),
        backgroundColor: myHexColor
      ),

      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            
            SizedBox( height: 100, ),

            _CategoryForm(),

            SizedBox( height: 100, )
            
          ],
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow.shade400,
        child: Icon( Icons.save_outlined, color: Colors.black ),
        onPressed: () async{
          if( !categoryForm.isValidForm() ) return;

          await categoryProvider.saveOrCreateCategory(categoryForm.category);
          
          Navigator.pop(context);
          
        },
      ),
    );
  }
}


class _CategoryForm extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    final category = categoryForm.category;
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 10 ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 200,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: categoryForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10,),

              TextFormField(
                initialValue: category.nombre,
                onChanged: ( value ) => category.nombre = value,
                validator: ( value ) {
                  if(value == null || value.length < 1)
                    return 'La categoria es obligatoria'; 
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre de la categoria',
                  labelText: 'Nombre de la categoria:'
                ),
              ),

              SizedBox(height: 30,),

              
              


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