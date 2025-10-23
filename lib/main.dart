import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Pages/recettes_page.dart';
import 'firebase_options.dart';
import 'homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      title: 'CuisineApp',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white), // ✅ Icône ☰ blanche
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/recets': (context) => const Recettespage(),
        // '/details': (context) => const detailsPage(),
      },
    ),
  );
}
