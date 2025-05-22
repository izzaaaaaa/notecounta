import 'package:flutter/material.dart';

// Deklarasi widget Home sebagai StatelessWidget
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold digunakan untuk membuat struktur halaman dasar (AppBar, Body, FAB, dll)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"), // Judul di bagian atas aplikasi
      ),
      body: ListView(), // Body kosong tapi bisa diisi list nota nantinya

      // Tombol bulat di kanan bawah untuk aksi tambah
      floatingActionButton: FloatingActionButton(
        // Fungsi ketika tombol ditekan
        onPressed: () => _showNotaDialog(context, nota),
        // Ikon "+" di dalam tombol
        child: const Icon(Icons.add),
      ),

      // Posisi tombol mengambang (pojok kanan bawah)
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

void _showNotaDialog({Nota? nota}) {
    // Inisialisasi variabel dengan data nota jika ada, atau default nilai jika tidak.
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
        // Dialog input formulir nota, baik untuk tambah maupun edit.
        return AlertDialog(
          title: Text(nota == null
              ? 'Tambah Nota'
              : 'Edit Nota'), // Judul dialog tergantung aksi.
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Pastikan kolom tidak terlalu besar.
            children: [
              // TextField untuk input tanggal dengan controller untuk menampilkan nilai awal.
              TextField(
                onChanged: (value) {
                  try {
                    tanggal = DateTime.parse(
                        value); // Update tanggal berdasarkan input string.
                  } catch (_) {
                    // Jika format tanggal salah, abaikan perubahan.
                  }
                },
                decoration: const InputDecoration(labelText: 'Tanggal'),
                controller:
                    TextEditingController(text: tanggal.toIso8601String()),
              ),
              // TextField untuk input nama.
              TextField(
                onChanged: (value) => nama = value,
                decoration: const InputDecoration(labelText: 'Nama'),
                controller: TextEditingController(text: nama),
              ),
              // TextField untuk input tipe HP.
              TextField(
                onChanged: (value) => typeHp = value,
                decoration: const InputDecoration(labelText: 'Type Hp'),
                controller: TextEditingController(text: typeHp),
              ),
              // TextField untuk input kerusakan.
              TextField(
                onChanged: (value) => kerusakan = value,
                decoration: const InputDecoration(labelText: 'Kerusakan'),
                controller: TextEditingController(text: kerusakan),
              ),
              // TextField untuk input kelengkapan.
              TextField(
                onChanged: (value) => kelengkapan = value,
                decoration: const InputDecoration(labelText: 'Kelengkapan'),
                controller: TextEditingController(text: kelengkapan),
              ),
              // TextField untuk input nomor HP, dengan keyboard number.
              TextField(
                onChanged: (value) => noHp = value,
                decoration: const InputDecoration(labelText: 'No Hp'),
                keyboardType: TextInputType.phone,
                controller: TextEditingController(text: noHp),
              ),
              // TextField untuk input harga, keyboard number, konversi input ke double.
              TextField(
                onChanged: (value) {
                  harga = double.tryParse(value) ??
                      0; // Jika gagal parse, default ke 0.
                },
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: TextEditingController(text: harga.toString()),
              ),
            ],
          ),
          actions: [
            // Tombol aksi untuk tambah atau simpan nota.
            TextButton(
              onPressed: () {
                if (nota == null) {
                  _addNota(tanggal, nama, typeHp, kerusakan, kelengkapan, noHp,
                      harga); // Jika nota null, berarti tambah nota baru.
                } else {
                  _updateNota(
                      nota.id,
                      tanggal,
                      nama,
                      typeHp,
                      kerusakan,
                      kelengkapan,
                      noHp,
                      harga); // Jika ada nota, update data nota.
                }
                Navigator.of(context).pop(); // Tutup dialog setelah aksi.
              },
              child: Text(
                  nota == null ? 'Tambah' : 'Simpan'), // Label sesuai aksi.
            ),
            // Tombol batal menutup dialog tanpa menyimpan perubahan.
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }











//DATABASE
// # Connect to Supabase via connection pooling
// DATABASE_URL="postgresql://postgres.ewdtwuhzqlbbnqalxhnm:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true"

// # Direct connection to the database. Used for migrations
// DIRECT_URL="postgresql://postgres.ewdtwuhzqlbbnqalxhnm:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres"
