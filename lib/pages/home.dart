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
        onPressed: () {
          // Navigasi ke halaman /notecounta saat tombol ditekan
          Navigator.pushNamed(context, "/notecounta");
        },

        // Ikon "+" di dalam tombol
        child: const Icon(Icons.add),
      ),

      // Posisi tombol mengambang (pojok kanan bawah)
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}











//DATABASE
// # Connect to Supabase via connection pooling
// DATABASE_URL="postgresql://postgres.ewdtwuhzqlbbnqalxhnm:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true"

// # Direct connection to the database. Used for migrations
// DIRECT_URL="postgresql://postgres.ewdtwuhzqlbbnqalxhnm:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres"
