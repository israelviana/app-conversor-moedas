import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Uri request = Uri.parse("https://api.hgbrasil.com/finance?key=3e1e86f4");

void main() async{
  runApp(MaterialApp(
    home: Main(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
    )
  );
}

Future<Map> requisition() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Main extends StatefulWidget {
  const Main({Key key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final realController = TextEditingController(text: '');
  final dolarController = TextEditingController(text: '');
  final euroController = TextEditingController(text: '');

  double dolar;
  double euro;

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
      double real = double.parse(text);
      dolarController.text = (real/dolar).toStringAsFixed(2);
      euroController.text = (real/euro).toStringAsFixed(2);

  }

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);

  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: requisition(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
              dolar = snapshot.data['results']['currencies']['USD']['buy'];
              euro = snapshot.data['results']['currencies']['EUR']['buy'];
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                      buildTextField("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euros", "€\$", euroController, _euroChanged)
                    ],
                  ),
                ),
              );
            }else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
              return Center(
                child: Text("Sem Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }else{
              return Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            }
          }),
    );
  }
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function f){
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.amber
        ),
        border: OutlineInputBorder(),
        prefixText: prefix,
        prefixStyle: TextStyle(
            color: Colors.amber,
            fontSize: 25
        )
    ),
    style: TextStyle(
        color: Colors.amber,
        fontSize: 25
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}


