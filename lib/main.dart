import 'package:flutter/material.dart';
import 'package:flutter_flix/core/constant.dart';
import 'package:flutter_flix/core/theme_app.dart';
import 'package:flutter_flix/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: kThemeApp,
      home: HomePage(),
    );
  }
}
