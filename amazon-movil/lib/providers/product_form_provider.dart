import 'package:amazon/models/models.dart';
import 'package:flutter/material.dart';


class ProductFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Producto product;

  ProductFormProvider( this.product );

  bool isValidForm() {


    return formKey.currentState?.validate() ?? false;
  }


}