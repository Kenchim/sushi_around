import 'package:flutter/material.dart';
import 'package:sushi_around/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_around/item_detail.dart';
import 'package:sushi_around/item_list.dart';
import 'package:sushi_around/searching.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sushi Around",
      theme: ThemeData(
        primarySwatch: buildMaterialColor(Color(0xffFFF9E2)),
        textTheme: GoogleFonts.comfortaaTextTheme()
        ),
      home: MyHomePage(),
    );
  }
}


// To apply Color class to Primary swatch
MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

