import 'package:flutter/material.dart';
import 'package:notecounta/pages/home.dart';
import 'package:notecounta/pages/notecounta.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  runApp(const MyApp());
  // await Supabase.initialize(
  //   url: 'https://ewdtwuhzqlbbnqalxhnm.supabase.co',
  //   anonkey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3ZHR3dWh6cWxiYm5xYWx4aG5tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0ODY1OTUsImV4cCI6MjA2MzA2MjU5NX0.riXjtK5QeshwwfQtQW-w7yeKi_meSgjOrSK4cKBe6Fw',
  // );
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
