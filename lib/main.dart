import 'package:flutter/material.dart';
import 'package:notecounta/pages/home.dart';
import 'package:notecounta/pages/notecounta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  runApp(const MyApp());
  await Supabase.initialize(
    url: 'https://emdsnpumittmsmolihuy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVtZHNucHVtaXR0bXNtb2xpaHV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc5NTgxNzgsImV4cCI6MjA2MzUzNDE3OH0.7NWD00SiQvzHaxAvFE-fxP5blktulazTDuf-Ax8_dQI',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 14, 169, 0)),
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
