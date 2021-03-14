import 'package:flutter/material.dart';
import 'package:flutter_flix/core/constant.dart';
import 'package:flutter_flix/core/theme_app.dart';
import 'package:flutter_flix/pages/home_page.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  // main do app
  runApp(FlutterFlix());
}

// classe Material principal
class FlutterFlix extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: kThemeApp,
      home: IntroPage(),
    );
  }
}

// classe que realiza a chamada para a primeira tela
// Tela de inicialização
class IntroPage extends StatefulWidget {
  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
}

// Predefinições para a Tela de inicialização
Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 5,
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xffFFD452), Color(0xffFFD452)],
        ),
        navigateAfterSeconds: HomePage(),
        loaderColor: Colors.transparent,
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/icon.png"),
            scale: 4.0,
            fit: BoxFit.none,
          ),
        ),
      ),
    ],
  );
}
