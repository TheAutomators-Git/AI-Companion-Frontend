import 'package:flutter/material.dart';
import 'pages/introduction_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Map<int, Color> color = {
      50: Color.fromRGBO(255, 87, 87, .1),
      100: Color.fromRGBO(255, 87, 87, .2),
      200: Color.fromRGBO(255, 87, 87, .3),
      300: Color.fromRGBO(255, 87, 87, .4),
      400: Color.fromRGBO(255, 87, 87, .5),
      500: Color.fromRGBO(255, 87, 87, .6),
      600: Color.fromRGBO(255, 87, 87, .7),
      700: Color.fromRGBO(255, 87, 87, .8),
      800: Color.fromRGBO(255, 87, 87, .9),
      900: Color.fromRGBO(255, 87, 87, 1),
    };

    MaterialColor customColor = const MaterialColor(0xFFFF5757, color);

    return MaterialApp(
      //Disable the debug banner
      debugShowCheckedModeBanner: false,
      title: 'AI Companion App',
      theme: ThemeData(
        primarySwatch: customColor,
        primaryColor: customColor,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF5757), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => IntroductionPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
