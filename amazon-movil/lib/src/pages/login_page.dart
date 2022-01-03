import 'dart:async';
import 'dart:convert';
import 'package:amazon/share_prefs/preferencias_usuario.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {

  

  @override
  _LoginPageState createState() => _LoginPageState();
  
}
 





class _LoginPageState extends State<LoginPage> {

  final LocalStorage storage = new LocalStorage('amazon');

  Color myHexColor = Color(0xff0F1111);
  final prefs = new PreferenciasUsuario();

  String _email = "";
  String _password = "";

  String _nombreUsuario = "";

  String usuario = "";

  String _estado = "";

  bool valuefirst = false;  
  bool valuesecond = false;  

  var url = Uri.parse('http://143.244.157.68:8080/api/auth/login');

  String msg='';

  

  Future<List> _loguearUsuario() async {
    
  
  var body = '''{\r\n    "correo": "$_email",\r\n    "password": "$_password"\r\n}''';  

  final response = await http.post(url, headers: {
    "content-type":"application/json; charset=UTF-8"
  }, body: body);

  var datauser = json.decode(response.body);

  usuario = jsonEncode(response.body);

  


  print(datauser);

  if(datauser['resultado'] == 1) {
    setState((){
      _estado = 'exito';
      _nombreUsuario = datauser['usuario']['nombre'];
      
      
    });
  }else{
    setState(() {
      _estado = 'Error';
      _nombreUsuario = "";
      
    });
  }
    
    return [];

}
   
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo-amazon.png', fit: BoxFit.cover, width: 180,),
        backgroundColor: myHexColor
      ),
      body: Center(

        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
          children: [
            
            _crearEmail(),
            Divider(),
            _crearPassword(),
            _checkboxContrasena(),
            Divider(),
            _botonLogin(),
            Divider()
            
          ],
        )
      ),
    );
  }

 

  Widget _crearPassword() {
    
    return TextField(
      obscureText: !this.valuefirst,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0)
        ),

        labelText: 'Contraseña',
        
        
      ),
      onChanged: (valor) {
        
        setState(() {
          _password = valor;
        });
      },
    );
  }

  Widget _crearEmail() {
    
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0)
        ),

        labelText: 'Correo electronico',
        
        
      ),
      onChanged: (valor) {
        
        setState(() {
          _email = valor;
        });
      },
    );
  }

  Widget _checkboxContrasena() {
    return Row(  
      children: <Widget>[  

        Checkbox(  
          checkColor: Colors.orange, 
          value: this.valuefirst,  
          onChanged: (bool? value) {  
            setState(() {  
              this.valuefirst = value!;  
            });  
          },  
        ),  
        Text('Mostrar contraseña ',style: TextStyle(fontSize: 17.0), ),  
      ],  
    );
  }

  Widget _botonLogin() {
    
    return Center(
        child: ElevatedButton(
          child: Text('Iniciar sesion', style: TextStyle(color: Colors.black, fontSize: 20.0),),
          onPressed: () async{
            await _loguearUsuario();
              
            if(_estado == "exito"){
              
              prefs.usuario = usuario;
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              );
            }else{
              prefs.usuario = "";

              showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context)  {

                

                return AlertDialog(
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
                      title: Text(_estado),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          
                          Text("Error!, los datos no son validos")
                          
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('Ok'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        
                      ],
                    );

                  }
                );
            }

            
            

          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(500, 53),
            primary: Colors.yellow.shade600,
          ),
          
        )
      );
  }

  

  
}