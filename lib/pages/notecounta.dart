import 'package:flutter/material.dart';

// Nota model class
class Nota {
  final int id;
  final DateTime tanggal;
  final String nama;
  final String typeHp;
  final String kelengkapan;
  final String kerusakan;
  final String noHp;
  final double harga;

  Nota({
    required this.id,
    required this.tanggal,
    required this.nama,
    required this.typeHp,
    required this.kelengkapan,
    required this.kerusakan,
    required this.noHp,
    required this.harga,
  });
}

class Notecounta extends StatefulWidget {
  const Notecounta({super.key, required this.title});
  final String title;

  @override
  State<Notecounta> createState() => _NotecountaState();
}

class _NotecountaState extends State<Notecounta> {
  final List<Nota> notas = [];
  int _nextId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {}, // Implement functionality for Name input
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              onChanged: (value) {}, // Implement functionality for typeHp input
              decoration: const InputDecoration(labelText: 'Type Hp'),
            ),
            TextField(
              onChanged: (value) {}, // Implement functionality for kelengkapan input
              decoration: const InputDecoration(labelText: 'Kelengkapan'),
            ),
            TextField(
              onChanged: (value) {}, // Implement functionality for kerusakan input
              decoration: const InputDecoration(labelText: 'Kerusakan'),
            ),
            TextField(
              onChanged: (value) {}, // Implement functionality for noHp input
              decoration: const InputDecoration(labelText: 'No Hp'),
            ),
            TextField(
              onChanged: (value) {}, // Implement functionality for harga input
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            ElevatedButton(
              onPressed: () {
                // Function to save data when the button is pressed
                DateTime tanggal = DateTime.now(); // You can use a DatePicker
                String nama = ''; // Replace with TextField values
                String typeHp = '';
                String kelengkapan = '';
                String kerusakan = '';
                String noHp = '';
                double harga = 0;

                // Add new nota
                setState(() {
                  notas.add(Nota(
                    id: _nextId++,
                    tanggal: tanggal,
                    nama: nama,
                    typeHp: typeHp,
                    kelengkapan: kelengkapan,
                    kerusakan: kerusakan,
                    noHp: noHp,
                    harga: harga,
                  ));
                });

                Navigator.pop(context); // Close the screen after adding data
              },
              child: const Text('Simpan Nota'),
            ),
          ],
        ),
      ),
    );
  }
}
