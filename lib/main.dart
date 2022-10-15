import 'package:flutter/material.dart';

const request = "https://api.hgbrasil.com/finance?key=3e1e86f4";

void main(){
  runApp(
    MaterialApp(
      home: Main(),
    )
  );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
