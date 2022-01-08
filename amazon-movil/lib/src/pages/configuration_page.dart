import 'package:flutter/material.dart';

class ConfigurationPage extends StatelessWidget {
  List<String> items = [ 'Configuracion', "Servicio al cliente", "Preguntas frecuentes", "Politicas de privacidad", "Vender en Amazon" ];
  @override
  Widget build(BuildContext context) {
    return Container(
            
      width: double.infinity,

      
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index ) => _ConfigurationContent( items[index] )
      ),
    );
  }

  
}

class _ConfigurationContent extends StatelessWidget {

    final String item;

    const _ConfigurationContent( this.item );
    
    
  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric( horizontal: 10, vertical: 10 ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black26,
          width: 3
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(5.0, 5.0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10)
      ),
      
      
      child: Row(
        children: [
          

          

          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints( maxWidth: 185 ),
                  child: Text(
                    "$item",
                    maxLines: 2,
                    style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    
                    
                    ),
                ),
                
              ],
            ),

          
          
        ],
      ),
    );

  }
  }