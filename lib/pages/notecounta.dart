import 'package:flutter/material.dart'; // Mengimpor paket Material Design Flutter untuk widget UI.
import 'package:notecounta/pages/nota.dart'; // Mengimpor model Nota untuk digunakan dalam aplikasi.

class Notecounta extends StatefulWidget {
  const Notecounta({super.key}); // Konstruktor dengan key opsional.

  @override
  NotecountaState createState() =>
      NotecountaState(); // Membuat state terkait untuk widget ini.
}

class NotecountaState extends State<Notecounta> {
  final List<Nota> notas = []; // Daftar untuk menampung semua objek Nota.
  int _nextId = 1; // Penanda ID berikutnya untuk nota baru.

  // Fungsi menambahkan nota baru ke daftar.
  void _addNota(DateTime tanggal, String nama, String typeHp, String kerusakan,
      String kelengkapan, String noHp, double harga) {
    setState(() {
      notas.add(Nota(
          id: _nextId++, // Tetapkan ID unik dan tingkatkan untuk berikutnya.
          tanggal: tanggal,
          nama: nama,
          typeHp: typeHp,
          kerusakan: kerusakan,
          kelengkapan: kelengkapan,
          noHp: noHp,
          harga: harga));
    });
  }

  // Fungsi mengupdate nota yang sudah ada berdasarkan ID.
  void _updateNota(int? id, DateTime tanggal, String nama, String typeHp,
      String kerusakan, String kelengkapan, String noHp, double harga) {
    setState(() {
      final index = notas.indexWhere(
          (nota) => nota.id == id); // Cari indeks nota dengan ID yang cocok.
      if (index != -1) {
        // Jika nota ditemukan.
        notas[index] = Nota(
            id: id,
            tanggal: tanggal,
            nama: nama,
            typeHp: typeHp,
            kerusakan: kerusakan,
            kelengkapan: kelengkapan,
            noHp: noHp,
            harga: harga); // Update objek Nota pada indeks tersebut.
      }
    });
  }

  // Fungsi menghapus nota berdasarkan ID.
  void _deleteNota(int? id) {
    setState(() {
      notas.removeWhere(
          (nota) => nota.id == id); // Hapus semua nota yang ID-nya sama.
    });
  }

  // Fungsi menampilkan dialog untuk tambah atau edit nota.
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

  @override
  Widget build(BuildContext context) {
    // Membangun UI utama halaman dengan scaffold.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota Konter'), // Judul aplikasi pada appbar.
      ),
      body: ListView.builder(
        itemCount: notas.length, // Jumlah item list sesuai total nota.
        itemBuilder: (context, index) {
          final nota = notas[index]; // Ambil nota pada indeks saat ini.
          return ListTile(
            title: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Rata kiri semua teks pada kolom.
              children: [
                Text(
                    'Tanggal: ${nota.tanggal.toLocal().toString().split(' ')[0]}'), // Tampilkan tanggal tanpa waktu.
                Text('Nama: ${nota.nama}'), // Tampilkan nama.
                Text('Type Hp: ${nota.typeHp}'), // Tampilkan tipe HP.
                Text('Kerusakan: ${nota.kerusakan}'), // Tampilkan kerusakan.
                Text(
                    'Kelengkapan: ${nota.kelengkapan}'), // Tampilkan kelengkapan.
                Text('No Hp: ${nota.noHp}'), // Tampilkan nomor HP.
                Text(
                    'Harga: Rp.${nota.harga.toStringAsFixed(3)}'), // Tampilkan harga dengan 3 desimal.
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // Batasi ukuran baris trailing.
              children: [
                // Tombol edit yang memanggil dialog edit dengan data nota.
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showNotaDialog(nota: nota),
                ),
                // Tombol hapus nota berdasarkan ID.
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteNota(nota.id!),
                ),
                
              ],
            ),
            
          );
        },
        
      ),
    );
  }
}