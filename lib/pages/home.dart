import 'package:flutter/material.dart';
import 'package:notecounta/pages/notecounta.dart';
// import 'package:notecounta/pages/nota.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Nota Konter'),
        centerTitle: true, // Judul di tengah
      ),
      body: const Center(
        child: Text(
          'Selamat datang!',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Notecounta()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}