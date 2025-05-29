import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List untuk menyimpan data input dari halaman Notecounta
  final List<Map<String, dynamic>> daftarData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: ListView.builder(
        itemCount: daftarData.length,
        itemBuilder: (context, index) {
          final item = daftarData[index];
          return ListTile(
            title: Text(item['nama'] ?? '-'),
            subtitle: Text("Tipe HP: ${item['typeHp'] ?? '-'}"),
            trailing: Text("Rp ${item['harga']?.toStringAsFixed(0) ?? '0'}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Menunggu hasil dari halaman Notecounta
          final hasil = await Navigator.pushNamed(context, "/notecounta");
          // print("Kembali dari notecounta: $hasil");
          // Jika hasil tidak null dan berupa Map, tambahkan ke daftar
          if (hasil is Map<String, dynamic>) {
            setState(() {
              daftarData.add(hasil);
            });
          }
        },
        tooltip: 'Tambah',
        child: const Icon(Icons.add),
      ),
    );
  }
}
