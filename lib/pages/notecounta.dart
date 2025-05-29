import 'package:flutter/material.dart';
import 'package:notecounta/pages/nota.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Notecounta extends StatefulWidget {
  const Notecounta({super.key});

  @override
  State<Notecounta> createState() => _NotecountaState();
}

class _NotecountaState extends State<Notecounta> {
  Nota? nota;
  bool initialized = false;

  final _formKey = GlobalKey<FormState>();

  DateTime tanggal = DateTime.now();
  String nama = '';
  String typeHp = '';
  String kerusakan = '';
  String kelengkapan = '';
  String noHp = '';
  double harga = 0.0;

  Future save() async {
    if (_formKey.currentState!.validate()) {
      final supabase = Supabase.instance.client;
      String message = 'Berhasil menyimpan catatan';

      Map<String, dynamic> dataToReturn = {
        'tanggal': tanggal,
        'nama': nama,
        'typeHp': typeHp,
        'kerusakan': kerusakan,
        'kelengkapan': kelengkapan,
        'noHp': noHp,
        'harga': harga,
      };

      if (nota != null) {
        await supabase.from('nota_konter').update({
          'tanggal': tanggal,
          'nama': nama,
          'typeHp': typeHp,
          'kerusakan': kerusakan,
          'kelengkapan': kelengkapan,
          'noHp': noHp,
          'harga': harga,
        }).eq('id', nota!.id!);
        message = 'Berhasil mengubah catatan';

        dataToReturn['id'] = nota!.id!;
      } else {
        final response = await supabase.from('nota_konter').insert({
          'tanggal': tanggal,
          'nama': nama,
          'typeHp': typeHp,
          'kerusakan': kerusakan,
          'kelengkapan': kelengkapan,
          'noHp': noHp,
          'harga': harga,
        }).select().single();

        dataToReturn['id'] = response['id'];
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      // print("Data berhasil disimpan: $dataToReturn");
      // Kembali ke halaman sebelumnya sambil mengirim data yang baru/diubah
      Navigator.pop(context, dataToReturn);
    }
  }

  Future delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus')),
          ],
        );
      },
    );

    if (confirmed == true) {
      final supabase = Supabase.instance.client;
      await supabase.from('nota_konter').delete().eq('id', nota?.id ?? '');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menghapus catatan')));
      Navigator.pop<String>(context, 'OK');
    }
  }

  @override
  Widget build(BuildContext context) {
    nota = ModalRoute.of(context)!.settings.arguments as Nota?;
    if (nota != null && !initialized) {
      setState(() {
        tanggal = nota!.tanggal;
        nama = nota?.nama ?? '';
        typeHp = nota?.typeHp ?? '';
        kerusakan = nota?.kerusakan ?? '';
        kelengkapan = nota?.kelengkapan ?? '';
        noHp = nota?.noHp ?? '';
        harga = nota?.harga ?? 0.0;
      });
      initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${(nota != null) ? 'Edit' : 'Buat'} Catatan"),
        actions: (nota != null)
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: delete,
                ),
              ]
            : [],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Tanggal'),
              initialValue: tanggal.toIso8601String(),
              onChanged: (value) => tanggal = DateTime.parse(value),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Tanggal wajib diisi'
                  : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama'),
              initialValue: nama,
              onChanged: (value) => nama = value,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Nama wajib diisi' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Tipe HP'),
              initialValue: typeHp,
              onChanged: (value) => typeHp = value,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Tipe HP wajib diisi'
                  : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Kerusakan'),
              initialValue: kerusakan,
              onChanged: (value) => kerusakan = value,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Kerusakan wajib diisi'
                  : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Kelengkapan'),
              initialValue: kelengkapan,
              onChanged: (value) => kelengkapan = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'No HP'),
              initialValue: noHp,
              onChanged: (value) => noHp = value,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'No HP wajib diisi' : null,
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Harga'),
                initialValue: harga.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => harga = double.tryParse(value) ?? 0.0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:Notecounta/pages/nota.dart';

// class Notecounta extends StatefulWidget {
//   const Notecounta({
//     super.key,
//     this.nota,
//   });

//   final Nota? nota;

//   @override
//   State<Notecounta> createState() => _NotecountaState();
// }

// class _NotecountaState extends State<Notecounta> {
//   final _formKey = GlobalKey<FormState>();

//   late DateTime tanggal;
//   final TextEditingController _namaController = TextEditingController();
//   final TextEditingController _typeHpController = TextEditingController();
//   final TextEditingController _kerusakanController = TextEditingController();
//   final TextEditingController _kelengkapanController = TextEditingController();
//   final TextEditingController _noHpController = TextEditingController();
//   final TextEditingController _hargaController = TextEditingController();

//   bool _isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.nota != null) {
//       _isEditing = true;
//       tanggal = widget.nota!.tanggal;
//       _namaController.text = widget.nota!.nama;
//       _typeHpController.text = widget.nota!.typeHp;
//       _kerusakanController.text = widget.nota!.kerusakan;
//       _kelengkapanController.text = widget.nota!.kelengkapan;
//       _noHpController.text = widget.nota!.noHp;
//       _hargaController.text = widget.nota!.harga.toStringAsFixed(0);
//     } else {
//       tanggal = DateTime.now();
//     }
//   }

//   @override
//   void dispose() {
//     _namaController.dispose();
//     _typeHpController.dispose();
//     _kerusakanController.dispose();
//     _kelengkapanController.dispose();
//     _noHpController.dispose();
//     _hargaController.dispose();
//     super.dispose();
//   }

//   Future<List<Map<String, dynamic>>> fetchNotas() async {
//     final supabase = Supabase.instance.client;
//     final response = await supabase.from('nota_konter').select();

//     if (response.isEmpty) {
//       throw Exception('Tidak ada data nota ditemukan.');
//     }

//     return List<Map<String, dynamic>>.from(response);
//   }

//   void _save() async {
//     if (_formKey.currentState!.validate()) {
//       final supabase = Supabase.instance.client;
//       final newNota = Nota(
//         id: _isEditing ? widget.nota!.id : null,
//         tanggal: tanggal,
//         nama: _namaController.text.trim(),
//         typeHp: _typeHpController.text.trim(),
//         kerusakan: _kerusakanController.text.trim(),
//         kelengkapan: _kelengkapanController.text.trim(),
//         noHp: _noHpController.text.trim(),
//         harga: double.tryParse(_hargaController.text.trim()) ?? 0,
//       );

//       final NotaMap = newNota.toMap();

//       if (_isEditing) {
//         final response =
//             await supabase.from('notas').update(NotaMap).eq('id', newNota.id!);
//         if (!mounted) return;
//         if (response.error != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Gagal update: ${response.error!.message}')),
//           );
//           return;
//         }
//       } else {
//         NotaMap.remove('id');
//         final response = await supabase.from('notas').insert(NotaMap);
//         if (!mounted) return;
//         if (response.error != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Gagal tambah: ${response.error!.message}')),
//           );
//           return;
//         }
//       }

//       if (!mounted) return;
//       Navigator.of(context).pop(newNota);
//     }
//   }

//   void _delete(int id) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Hapus Nota'),
//         content: const Text('Apakah Anda yakin ingin menghapus nota ini?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final supabase = Supabase.instance.client;
//               Navigator.of(ctx).pop();
//               final response =
//                   await supabase.from('notas').delete().eq('id', id);
//               if (!mounted) return;
//               if (response.error != null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                       content: Text('Gagal hapus: ${response.error!.message}')),
//                 );
//                 return;
//               }
//               if (!mounted) return;
//               Navigator.of(context).pop('delete');
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Hapus'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isEditing ? 'Edit Nota' : 'Tambah Nota'),
//         actions: [
//           if (_isEditing)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () => _delete(widget.nota!.id!),
//               tooltip: 'Hapus Nota',
//             ),
//         ],
//       ),
//       body: _isEditing
//           ? _buildForm()
//           : FutureBuilder<List<Map<String, dynamic>>>(
//               future: fetchNotas(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final Notas = snapshot.data!;
//                 if (Notas.isEmpty) {
//                   return const Center(child: Text('Belum ada data nota'));
//                 }
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: Notas.length,
//                   itemBuilder: (context, index) {
//                     final NotaMap = Notas[index];
//                     final Nota = Nota.fromMap(NotaMap);
//                     return Card(
//                       child: ListTile(
//                         title: Text(Nota.nama),
//                         subtitle: Text(
//                             'Type HP: ${Nota.typeHp}\nKerusakan: ${Nota.kerusakan}'),
//                         trailing: Text('Rp ${Nota.harga.toStringAsFixed(0)}'),
//                         onTap: () async {
//                           final result = await Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => Notecounta(nota: Nota),
//                             ),
//                           );
//                           if (result == 'delete' || result is Nota) {
//                             setState(
//                                 () {}); // Refresh list setelah edit atau hapus
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }

//   Widget _buildForm() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _namaController,
//               decoration: const InputDecoration(
//                 labelText: 'Nama',
//                 prefixIcon: Icon(Icons.person),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Nama wajib diisi';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _typeHpController,
//               decoration: const InputDecoration(
//                 labelText: 'Type HP',
//                 prefixIcon: Icon(Icons.phone_android),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Type HP wajib diisi';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _kerusakanController,
//               decoration: const InputDecoration(
//                 labelText: 'Kerusakan',
//                 prefixIcon: Icon(Icons.build),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Kerusakan wajib diisi';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _kelengkapanController,
//               decoration: const InputDecoration(
//                 labelText: 'Kelengkapan',
//                 prefixIcon: Icon(Icons.inventory),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _noHpController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: 'No HP',
//                 prefixIcon: Icon(Icons.phone),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'No HP wajib diisi';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _hargaController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Harga',
//                 prefixIcon: Icon(Icons.attach_money),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Harga wajib diisi';
//                 }
//                 final n = double.tryParse(value.trim());
//                 if (n == null || n < 0) {
//                   return 'Masukkan harga yang valid';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _save,
//               icon: const Icon(Icons.save),
//               label: Text(_isEditing ? 'Simpan Perubahan' : 'Simpan'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(48),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







// //coding lama

// //   // Fungsi menambahkan nota baru ke daftar.
// //   void _addNota(DateTime tanggal, String nama, String typeHp, String kerusakan,
// //       String kelengkapan, String noHp, double harga) {
// //     setState(() {
// //       notas.add(Nota(
// //           id: _nextId++, // Tetapkan ID unik dan tingkatkan untuk berikutnya.
// //           tanggal: tanggal,
// //           nama: nama,
// //           typeHp: typeHp,
// //           kerusakan: kerusakan,
// //           kelengkapan: kelengkapan,
// //           noHp: noHp,
// //           harga: harga));
// //     });
// //   }

// //   // Fungsi mengupdate nota yang sudah ada berdasarkan ID.
// //   void _updateNota(int? id, DateTime tanggal, String nama, String typeHp,
// //       String kerusakan, String kelengkapan, String noHp, double harga) {
// //     setState(() {
// //       final index = notas.indexWhere(
// //           (nota) => nota.id == id); // Cari indeks nota dengan ID yang cocok.
// //       if (index != -1) {
// //         // Jika nota ditemukan.
// //         notas[index] = Nota(
// //             id: id,
// //             tanggal: tanggal,
// //             nama: nama,
// //             typeHp: typeHp,
// //             kerusakan: kerusakan,
// //             kelengkapan: kelengkapan,
// //             noHp: noHp,
// //             harga: harga); // Update objek Nota pada indeks tersebut.
// //       }
// //     });
// //   }

// //   // Fungsi menghapus nota berdasarkan ID.
// //   void _deleteNota(int? id) {
// //     setState(() {
// //       notas.removeWhere(
// //           (nota) => nota.id == id); // Hapus semua nota yang ID-nya sama.
// //     });
// //   }

// //   // Fungsi menampilkan dialog untuk tambah atau edit nota.
// //   void _showNotaDialog({Nota? nota}) {
// //     // Inisialisasi variabel dengan data nota jika ada, atau default nilai jika tidak.
// //     DateTime tanggal = nota?.tanggal ?? DateTime.now();
// //     String nama = nota?.nama ?? '';
// //     String typeHp = nota?.typeHp ?? '';
// //     String kerusakan = nota?.kerusakan ?? '';
// //     String kelengkapan = nota?.kelengkapan ?? '';
// //     String noHp = nota?.noHp ?? '';
// //     double harga = nota?.harga ?? 0;

// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         // Dialog input formulir nota, baik untuk tambah maupun edit.
// //         return AlertDialog(
// //           title: Text(nota == null
// //               ? 'Tambah Nota'
// //               : 'Edit Nota'), // Judul dialog tergantung aksi.
// //           content: Column(
// //             mainAxisSize:
// //                 MainAxisSize.min, // Pastikan kolom tidak terlalu besar.
// //             children: [
// //               // TextField untuk input tanggal dengan controller untuk menampilkan nilai awal.
// //               TextField(
// //                 onChanged: (value) {
// //                   try {
// //                     tanggal = DateTime.parse(
// //                         value); // Update tanggal berdasarkan input string.
// //                   } catch (_) {
// //                     // Jika format tanggal salah, abaikan perubahan.
// //                   }
// //                 },
// //                 decoration: const InputDecoration(labelText: 'Tanggal'),
// //                 controller:
// //                     TextEditingController(text: tanggal.toIso8601String()),
// //               ),
// //               // TextField untuk input nama.
// //               TextField(
// //                 onChanged: (value) => nama = value,
// //                 decoration: const InputDecoration(labelText: 'Nama'),
// //                 controller: TextEditingController(text: nama),
// //               ),
// //               // TextField untuk input tipe HP.
// //               TextField(
// //                 onChanged: (value) => typeHp = value,
// //                 decoration: const InputDecoration(labelText: 'Type Hp'),
// //                 controller: TextEditingController(text: typeHp),
// //               ),
// //               // TextField untuk input kerusakan.
// //               TextField(
// //                 onChanged: (value) => kerusakan = value,
// //                 decoration: const InputDecoration(labelText: 'Kerusakan'),
// //                 controller: TextEditingController(text: kerusakan),
// //               ),
// //               // TextField untuk input kelengkapan.
// //               TextField(
// //                 onChanged: (value) => kelengkapan = value,
// //                 decoration: const InputDecoration(labelText: 'Kelengkapan'),
// //                 controller: TextEditingController(text: kelengkapan),
// //               ),
// //               // TextField untuk input nomor HP, dengan keyboard number.
// //               TextField(
// //                 onChanged: (value) => noHp = value,
// //                 decoration: const InputDecoration(labelText: 'No Hp'),
// //                 keyboardType: TextInputType.phone,
// //                 controller: TextEditingController(text: noHp),
// //               ),
// //               // TextField untuk input harga, keyboard number, konversi input ke double.
// //               TextField(
// //                 onChanged: (value) {
// //                   harga = double.tryParse(value) ??
// //                       0; // Jika gagal parse, default ke 0.
// //                 },
// //                 decoration: const InputDecoration(labelText: 'Harga'),
// //                 keyboardType:
// //                     const TextInputType.numberWithOptions(decimal: true),
// //                 controller: TextEditingController(text: harga.toString()),
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             // Tombol aksi untuk tambah atau simpan nota.
// //             TextButton(
// //               onPressed: () {
// //                 if (nota == null) {
// //                   _addNota(tanggal, nama, typeHp, kerusakan, kelengkapan, noHp,
// //                       harga); // Jika nota null, berarti tambah nota baru.
// //                 } else {
// //                   _updateNota(
// //                       nota.id,
// //                       tanggal,
// //                       nama,
// //                       typeHp,
// //                       kerusakan,
// //                       kelengkapan,
// //                       noHp,
// //                       harga); // Jika ada nota, update data nota.
// //                 }
// //                 Navigator.of(context).pop(); // Tutup dialog setelah aksi.
// //               },
// //               child: Text(
// //                   nota == null ? 'Tambah' : 'Simpan'), // Label sesuai aksi.
// //             ),
// //             // Tombol batal menutup dialog tanpa menyimpan perubahan.
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(),
// //               child: const Text('Batal'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Membangun UI utama halaman dengan scaffold.
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Nota Konter'), // Judul aplikasi pada appbar.
// //       ),
// //       body: ListView.builder(
// //         itemCount: notas.length, // Jumlah item list sesuai total nota.
// //         itemBuilder: (context, index) {
// //           final nota = notas[index]; // Ambil nota pada indeks saat ini.
// //           return ListTile(
// //             title: Column(
// //               crossAxisAlignment:
// //                   CrossAxisAlignment.start, // Rata kiri semua teks pada kolom.
// //               children: [
// //                 Text(
// //                     'Tanggal: ${nota.tanggal.toLocal().toString().split(' ')[0]}'), // Tampilkan tanggal tanpa waktu.
// //                 Text('Nama: ${nota.nama}'), // Tampilkan nama.
// //                 Text('Type Hp: ${nota.typeHp}'), // Tampilkan tipe HP.
// //                 Text('Kerusakan: ${nota.kerusakan}'), // Tampilkan kerusakan.
// //                 Text(
// //                     'Kelengkapan: ${nota.kelengkapan}'), // Tampilkan kelengkapan.
// //                 Text('No Hp: ${nota.noHp}'), // Tampilkan nomor HP.
// //                 Text(
// //                     'Harga: Rp.${nota.harga.toStringAsFixed(3)}'), // Tampilkan harga dengan 3 desimal.
// //               ],
// //             ),
// //             trailing: Row(
// //               mainAxisSize: MainAxisSize.min, // Batasi ukuran baris trailing.
// //               children: [
// //                 // Tombol edit yang memanggil dialog edit dengan data nota.
// //                 IconButton(
// //                   icon: const Icon(Icons.edit),
// //                   onPressed: () => _showNotaDialog(nota: nota),
// //                 ),
// //                 // Tombol hapus nota berdasarkan ID.
// //                 IconButton(
// //                   icon: const Icon(Icons.delete),
// //                   onPressed: () => _deleteNota(nota.id!),
// //                 ),
                
// //               ],
// //             ),
            
// //           );
// //         },
        
// //       ),
// //     );
// //   }
// // }