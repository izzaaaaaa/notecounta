import 'package:flutter/material.dart';
import 'package:notecounta/pages/home.dart';
import 'package:notecounta/pages/notecounta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nota Konter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 5, 207, 36)),
        useMaterial3: true,
      ),
      // home: const Home(title: 'Nota Konter'),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/notecounta': (context) => const Notecounta(),
      },
    );
  }
}