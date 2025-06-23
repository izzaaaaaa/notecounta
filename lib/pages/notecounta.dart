import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart'; // untuk format tanggal dan angka
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:notecounta/pages/nota.dart'; 


class Notecounta extends StatefulWidget { //untuk halaman daftar nota
  const Notecounta({super.key}); 

  @override
  State<Notecounta> createState() => _NotecountaState(); // untuk Membuat state _NotecountaState
}

class _NotecountaState extends State<Notecounta> {
  final supabase = Supabase.instance.client; // Instance client Supabase untuk query database
  List<Map<String, dynamic>> notaList = []; // List untuk menyimpan data nota yang diambil dari database
  bool loading = false; // Status loading untuk menampilkan progress indicator saat mengambil data

  final DateFormat _dateFormat = DateFormat('dd - MM - yyyy'); // Formatter tanggal untuk tampilan tanggal

  @override
  void initState() {
    super.initState(); // Memanggil initState dari superclass
    fetchNota(); // Memanggil method fetchNota saat widget diinisialisasi untuk mengambil data dari Supabase
  }

  Future<void> fetchNota() async { // Fungsi async untuk mengambil data nota dari database Supabase
    setState(() {
      loading = true; // Set loading true sebelum mulai query
    });

    try {
      final data = await supabase
          .from('nota_konter') // Pilih tabel 'nota'
          .select() // Ambil semua kolom
          .order('tanggal', ascending: false); // Urutkan data berdasarkan tanggal terbaru

      setState(() {
        notaList = List<Map<String, dynamic>>.from(data); // Simpan data hasil query ke notaList dalam bentuk List<Map>
      });
    } catch (e) {
      if (mounted) { // Cek apakah widget masih aktif sebelum tampilkan snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data: $e')), // Tampilkan pesan error jika gagal
        );
      }
    } finally {
      setState(() {
        loading = false; // Set loading false setelah proses selesai
      });
    }
  }

  Future<void> deleteNota(String id) async { // Fungsi async untuk menghapus data nota berdasarkan id
    final confirm = await showDialog<bool>( // Menampilkan dialog konfirmasi hapus data
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'), 
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'), // Isi dialog
        actions: [ // Tombol aksi dialog
          TextButton(
              onPressed: () => Navigator.pop(context, false), // Tombol aksi batal
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true), // TTombol aksi hapus
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm != true) return; // Jika tidak konfirmasi hapus, keluar dari fungsi

    setState(() {
      loading = true; // Set loading true saat proses hapus data berjalan
    });

    try {
      await supabase.from('nota_konter').delete().eq('id', id); // Query hapus data dari tabel 'nota' berdasarkan id

      if (mounted) { // Cek widget masih aktif
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dihapus')), // Tampilkan pesan berhasil hapus
        );
      }

      await fetchNota(); // Refresh data setelah hapus
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: $e')), // menampilkan pesan gagal hapus jika error
        );
      }
    } finally {
      setState(() {
        loading = false; // Set loading false setelah proses selesai
      });
    }
  }

  Future<void> navigasiFormTambah() async { // Fungsi untuk navigasi ke halaman tambah nota
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Nota()), // Navigasi ke halaman Nota tanpa data (tambah baru)
    );
    if (result == true) {
      await fetchNota(); // Jika tambah berhasil (return true), refresh daftar nota
    }
  }

  Future<void> navigasiFormEdit(Map<String, dynamic> nota) async { // Fungsi untuk navigasi ke halaman edit nota
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Nota(notaData: nota)), // Navigasi ke halaman Nota dengan data nota untuk edit
    );
    if (result == true) {
      await fetchNota(); // Jika edit berhasil (return true), refresh daftar nota
    }
  }

  @override
  Widget build(BuildContext context) { // Build method untuk membangun UI halaman Notecounta
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Nota Konter'), // Judul app bar halaman
      ),
      body: loading // Cek status loading
          ? const Center(child: CircularProgressIndicator()) // Jika loading true, tampilkan loading spinner
          : RefreshIndicator( // Widget untuk pull-to-refresh
              onRefresh: fetchNota, // Saat refresh, panggil fetchNota
              child: notaList.isEmpty // Cek apakah data nota kosong
                  ? ListView( // Jika kosong, tampilkan pesan 'Belum ada data'
                      physics: const AlwaysScrollableScrollPhysics(), // Agar bisa di-pull walau kosong
                      children: const [
                        SizedBox(height: 40), // Spacer atas
                        Center(child: Text('Belum ada data')), // Pesan kosong
                      ],
                    )
                  : ListView.separated( // Jika ada data, tampilkan list dengan separator
                      padding: const EdgeInsets.all(8), // Padding di sekitar list
                      itemCount: notaList.length, // Jumlah item sesuai panjang data notaList
                      separatorBuilder: (_, __) => const Divider(), // Separator garis antar item
                      itemBuilder: (context, index) { // Fungsi builder tiap item list
                        final nota = notaList[index]; // Ambil data nota pada index tertentu
                        return ListTile( // Widget list tile untuk menampilkan data nota
                          title: Text(nota['nama'] ?? ''), // Judul tile adalah nama pelanggan
                          subtitle: Column( // Subtitle berisi beberapa info nota
                            crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri semua teks
                            children: [
                              Text('Tanggal : ${_dateFormat.format(DateTime.parse(nota['tanggal']))}'), // Ambil tanggal dari data nota, // Tanggal format dd - MM - yyyy
                              Text('Type HP : ${nota['type_hp']}'), 
                              Text('Kerusakan : ${nota['kerusakan']}'), 
                              Text('Kelengkapan : ${nota['kelengkapan']}'), 
                              Text('No HP : ${nota['no_hp']}'), 
                              Text(
                                  'Harga : Rp.${NumberFormat('#,###', 'id_ID').format(nota['harga']).replaceAll(',', '.')}'), // Harga diformat dengan ribuan dan titik sebagai pemisah
                            ],
                          ),
                          // isThreeLine: true, // menampilkan tiga baris teks
                          trailing: PopupMenuButton<String>( // Tombol menu popup di kanan untuk opsi edit/hapus
                            onSelected: (value) { // Handler saat memilih menu
                              if (value == 'edit') {
                                navigasiFormEdit(nota); // Jika pilih edit, buka halaman edit nota
                              } else if (value == 'delete') {
                                deleteNota(nota['id']); // Jika pilih hapus, panggil fungsi deleteNota
                              }
                            },
                            itemBuilder: (_) => [ // Daftar menu popup
                              const PopupMenuItem(
                                value: 'edit', // Value edit
                                child: Text('Edit'), // Label edit
                              ),
                              const PopupMenuItem(
                                value: 'delete', // Value hapus
                                child: Text('Hapus'), // Label hapus
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton( // Tombol mengambang untuk tambah nota baru
        onPressed: navigasiFormTambah, // Saat ditekan, buka halaman tambah nota
        tooltip: 'Tambah Nota', // Tooltip tombol
        child: const Icon(Icons.add), // Icon tambah (+)
      ),
    );
  }
}
