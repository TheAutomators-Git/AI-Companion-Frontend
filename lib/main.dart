import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // Import provider
import 'pages/introduction_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/categories_page.dart';
import 'pages/display_page.dart';
import 'providers/category_selection_provider.dart'; // Import the provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String apiUrl = dotenv.env['API_URL'] ?? 'http://default_url';

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

    return ChangeNotifierProvider( // Wrap your app with ChangeNotifierProvider
      create: (context) => CategorySelectionProvider(), // Provide CategorySelectionProvider
      child: MaterialApp(
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
          '/home': (context) => HomePage(apiUrl: apiUrl),
          '/introduction': (context) => IntroductionPage(),
          '/display': (context) => DisplayPage(),
          '/categories': (context) => CategoriesPage(),
        },
      ),
    );
  }
}
