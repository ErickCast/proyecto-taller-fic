
import 'package:amazon/models/models.dart';
import 'package:flutter/material.dart';


class CategoryFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Categoria category;

  CategoryFormProvider( this.category );


  

  bool isValidForm() {


    return formKey.currentState?.validate() ?? false;
  }


}