// home.dart
import 'package:flutter/material.dart';
import 'package:notecounta/pages/notecounta.dart';  // Pastikan sudah ada akses ke Notecounta

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final List<Nota> notas = []; // Daftar nota yang disimpan di Home
  int _nextId = 1; // Untuk ID auto increment

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Nota Konter'),
      ),
      body: ListView.builder(
        itemCount: notas.length, // Menampilkan jumlah nota yang ada
        itemBuilder: (context, index) {
          final nota = notas[index];
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal: ${nota.tanggal}'),
                Text('Nama: ${nota.nama}'),
                Text('Type Hp: ${nota.typeHp}'),
                Text('Kelengkapan: ${nota.kelengkapan}'),
                Text('Kerusakan: ${nota.kerusakan}'),
                Text('No Hp: ${nota.noHp}'),
                Text('Harga: ${nota.harga}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showNotaDialog(nota: nota); // Menampilkan dialog edit
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNotaDialog(); // Menampilkan dialog untuk menambah nota baru
        },
        tooltip: 'Masukkan data',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dialog untuk menambah atau mengedit nota
  void showNotaDialog({Nota? nota}) {
    DateTime tanggal = nota?.tanggal ?? DateTime.now();
    String nama = nota?.nama ?? '';
    String typeHp = nota?.typeHp ?? '';
    String kelengkapan = nota?.kelengkapan ?? '';
    String kerusakan = nota?.kerusakan ?? '';
    String noHp = nota?.noHp ?? '';
    double harga = nota?.harga ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(nota == null ? 'Tambah Nota' : 'Edit Nota'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => tanggal = DateTime.parse(value),
                decoration: const InputDecoration(labelText: 'Tanggal'),
                controller: TextEditingController(text: tanggal.toString()),
              ),
              TextField(
                onChanged: (value) => nama = value,
                decoration: const InputDecoration(labelText: 'Nama'),
                controller: TextEditingController(text: nama),
              ),
              TextField(
                onChanged: (value) => typeHp = value,
                decoration: const InputDecoration(labelText: 'Type Hp'),
                controller: TextEditingController(text: typeHp),
              ),
              TextField(
                onChanged: (value) => kelengkapan = value,
                decoration: const InputDecoration(labelText: 'Kelengkapan'),
                controller: TextEditingController(text: kelengkapan),
              ),
              TextField(
                onChanged: (value) => kerusakan = value,
                decoration: const InputDecoration(labelText: 'Kerusakan'),
                controller: TextEditingController(text: kerusakan),
              ),
              TextField(
                onChanged: (value) => noHp = value,
                decoration: const InputDecoration(labelText: 'No Hp'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: noHp),
              ),
              TextField(
                onChanged: (value) {
                  harga = double.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: harga.toString()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nota == null) {
                  addNota(tanggal, nama, typeHp, kelengkapan, kerusakan, noHp, harga); // Menambah nota baru
                } else {
                  // Bisa ditambahkan logika untuk mengedit nota
                }
                Navigator.of(context).pop(); // Tutup dialog setelah menyimpan
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Batal
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menambah nota ke dalam daftar
  void addNota(
    DateTime tanggal,
    String nama,
    String typeHp,
    String kelengkapan,
    String kerusakan,
    String noHp,
    double harga,
  ) {
    setState(() {
      notas.add(Nota(
        id: _nextId++, // ID auto increment
        tanggal: tanggal,
        nama: nama,
        typeHp: typeHp,
        kelengkapan: kelengkapan,
        kerusakan: kerusakan,
        noHp: noHp,
        harga: harga,
      ));
    });
  }
}
