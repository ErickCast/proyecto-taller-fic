import 'package:amazon/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OrdersProvider extends ChangeNotifier {
  
  String _apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI2MTY2N2Y4ODJiYjk1OGFkOGEwNDIyZDYiLCJpYXQiOjE2MzQ3OTcxMjIsImV4cCI6MTYzNTQwMTkyMn0.jRUanZ_0vnpBYW1CxJl4ZYHIm50MdFHIZvDfHNn823o';

  List<Orden> ordenes = [];

  OrdersProvider() {
    print("Inicializando provider ordenes");


  }

  Future<List<Orden>> getOrdersByUserId(id) async {
    var url = Uri.parse('http://143.244.157.68:8080/api/ordenes/getOrdenesByUsuario/$id');

    final response = await http.get( url );
    final productosResponse = OrderModel.fromJson(response.body);

    return productosResponse.ordenes;

  }
}