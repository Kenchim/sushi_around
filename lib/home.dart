import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_around/searching.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState(){
    Timer(const Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return Searching();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF9E2),
      body: 
      Column(
         children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.45,),
          Container(
            child: Center(
            child: Text("Sushi Around", 
              style: TextStyle(
                fontSize: 48, 
                fontWeight: FontWeight.bold),)
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image(image: AssetImage("images/logo_sushitech.png"),width: 70,),
                SizedBox(height: 10,),
                Text("by SUSHI TECH"),
              ], 
            ),
          ),
          SizedBox(height: 50,)
         ]
    ),);
  }
}