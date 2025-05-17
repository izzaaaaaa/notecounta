import 'package:flutter/material.dart';

class Nota {
  final int id;
  final DateTime tanggal;
  final String nama;
  final String typeHp;
  final String kerusakan;
  final String kelengkapan;
  final String noHp;
  final double harga;

  Nota(
      {required this.id,
      required this.tanggal,
      required this.nama,
      required this.typeHp,
      required this.kerusakan,
      required this.kelengkapan,
      required this.noHp,
      required this.harga});
}

class Notecounta extends StatefulWidget {
  const Notecounta({super.key});
  @override
  NotecountaState createState() => NotecountaState();
}

class NotecountaState extends State<Notecounta> {
  final List<Nota> notas = [];
  int _nextId = 1;

  void _addNota(DateTime tanggal, String nama, String typeHp, String kerusakan,
      String kelengkapan, String noHp, double harga) {
    setState(() {
      notas.add(Nota(
          id: _nextId++,
          tanggal: tanggal,
          nama: nama,
          typeHp: typeHp,
          kerusakan: kerusakan,
          kelengkapan: kelengkapan,
          noHp: noHp,
          harga: harga));
    });
  }

  void _updateNota(int id, DateTime tanggal, String nama, String typeHp,
      String kerusakan, String kelengkapan, String noHp, double harga) {
    setState(() {
      final index = notas.indexWhere((nota) => nota.id == id);
      if (index != -1) {
        notas[index] = Nota(
            id: id,
            tanggal: tanggal,
            nama: nama,
            typeHp: typeHp,
            kerusakan: kerusakan,
            kelengkapan: kelengkapan,
            noHp: noHp,
            harga: harga);
      }
    });
  }

  void _deleteNota(int id) {
    setState(() {
      notas.removeWhere((nota) => nota.id == id);
    });
  }

  void _showNotaDialog({Nota? nota}) {
    DateTime tanggal = nota?.tanggal ?? DateTime.now();
    String nama = nota?.nama ?? '';
    String typeHp = nota?.typeHp ?? '';
    String kerusakan = nota?.kerusakan ?? '';
    String kelengkapan = nota?.kelengkapan ?? '';
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
                decoration: const InputDecoration(labelText: 'Kerusakan'),
                controller: TextEditingController(text: kelengkapan),
              ),
              TextField(
                onChanged: (value) => kerusakan = value,
                decoration: const InputDecoration(labelText: 'Kelengkapan'),
                controller: TextEditingController(text: kerusakan),
              ),
              TextField(
                onChanged: (value) => noHp = value,
                decoration: const InputDecoration(labelText: 'No Hp'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: noHp.toString()),
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
                  _addNota(tanggal, nama, typeHp, kerusakan, kelengkapan, noHp,
                      harga);
                } else {
                  _updateNota(nota.id, tanggal, nama, typeHp, kerusakan,
                      kelengkapan, noHp, harga);
                }
                Navigator.of(context).pop();
              },
              child: Text(nota == null ? 'Tambah' : 'Simpan'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota Konter'),
      ),
      body: ListView.builder(
        itemCount: notas.length,
        itemBuilder: (context, index) {
          final nota = notas[index];
          return ListTile(
            title: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Agar teks rata kiri
              children: [
                Text('Tanggal: ${nota.tanggal}'), // Menampilkan tanggal
                Text('Nama: ${nota.nama}'), // Menampilkan nama di bawah tanggal
                Text('Type Hp: ${nota.typeHp}'),
                Text('Kerusakan: ${nota.kerusakan}'),
                Text('Kelengkapan: ${nota.kelengkapan}'),
                Text('No Hp: ${nota.noHp}'),
                Text('Harga: ${nota.harga}')
              ],
            ),
            // subtitle: Text('Harga: ${nota.harga}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showNotaDialog(nota: nota),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteNota(nota.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNotaDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
