import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'home_page.dart';
import 'login_page.dart';

import 'package:flutter/services.Dart';



class RegisterPage extends StatefulWidget {

  

  @override
  _RegisterPageState createState() => _RegisterPageState();
  
}
 





class _RegisterPageState extends State<RegisterPage> {

Color myHexColor = Color(0xff0F1111);

  String _nombre = "";
  String _email = "";
  String _password = "";

  String _estado = "";
  String _mensaje = "";

  bool valuefirst = false;  
  bool valuesecond = false;  

  var url = Uri.parse('http://143.244.157.68:8080/api/usuarios');

  String msg='';

  

  Future<List> _registrarUsuario() async {
  
  var body = '''{\r\n    "nombre": "$_nombre",\r\n    "telefono": "",\r\n    "correo": "$_email",\r\n    "password": "$_password",\r\n    "estado": "",\r\n    "ciudad": "",\r\n    "domicilio": "",\r\n     "rol": "USER_ROLE"\r\n}''';

  final response = await http.post(url, headers: {
    "content-type":"application/json; charset=UTF-8"
  }, body: body);

  var datauser = json.decode(response.body);

  if(datauser['resultado'] == 1) {
    setState(() {
      _estado = "¡Registrado con exito!";
      _mensaje = datauser['msg'];
      
    });
  }else{
    setState(() {
      _estado = "Error";
      
      
    });
  }

  
    
    print("1");
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
            
            _inputNombre(),
            Divider(),
            _crearEmail(),
            Divider(),
            _crearPassword(),
            _checkboxContrasena(),
            Divider(),
            _botonRegistrar(),
            Divider(),
            Text('Al crear una cuenta, aceptas las Condiciones de Uso y el Aviso de Privacidad de Amazon.', style: TextStyle(fontSize: 16.0),),
            Divider(),
            _textoLogin()

          ],
        )
      ),
    );
  }

  Widget _inputNombre() {
  //Creacion de campos para formulario
    return TextField(
      //autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0)
        ),
        labelText: 'Nombre',
        
        
      ),
      onChanged: (valor) {
       
        setState(() {
          _nombre = valor;
        });
      },
    );
  }

  Widget _textoLogin(){
    return Center(
          child: new RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                  text: '¿Ya tienes una cuenta? ',
                  style: new TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                new TextSpan(
                  text: 'Iniciar sesión',
                  style: new TextStyle(color: Colors.blue, fontSize: 16.0),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () { 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                  },
                ),
              ],
            ),
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

  Widget _botonRegistrar() {
    return Center(
        child: ElevatedButton(
          child: Text('Continuar', style: TextStyle(color: Colors.black, fontSize: 20.0),),
          onPressed: () async{
            await _registrarUsuario();

            _mostrarAlert(context);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(500, 53),
            primary: Colors.yellow.shade600,
          ),
          
        )
      );
  }

  void _mostrarAlert(BuildContext context) {
    print("2");
    if(_estado == "¡Registrado con exito!"){
      setState(() {
        
        _mensaje = _mensaje + ", Inicia sesion para ingresar con tu cuenta";
        
      });

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
                  
                  Text(_mensaje)
                  
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Ir al login'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                ),
              ],
            );

          }
        );
      
    }else{
      setState(() {
        _mensaje = "Los datos no son validos, intentalo de nuevo";
      });

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
                  
                  Text(_mensaje)
                  
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
    
  }



  
}