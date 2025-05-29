import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future fetchNota() async {
  final supabase = Supabase.instance.client;

  final data = await supabase.from('nota_konter').select();
  return data;
}

class Nota {
  final int? id;
  final DateTime tanggal;
  final String nama;
  final String typeHp;
  final String kerusakan;
  final String kelengkapan;
  final String noHp;
  final double harga;

  const Nota({
    required this.id,
    required this.tanggal,
    required this.nama,
    required this.typeHp,
    required this.kerusakan,
    required this.kelengkapan,
    required this.noHp,
    required this.harga,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'tanggal': DateTime tanggal,
        'nama': String nama,
        'type_hp': String typeHp,
        'kerusakan': String kerusakan,
        'kelengkapan': String kelengkapan,
        'no_hp':  String noHp,
        'harga': double harga,
      } =>
        Nota(id: id, tanggal: tanggal, nama: nama, typeHp: typeHp, kerusakan: kerusakan, kelengkapan: kelengkapan, noHp: noHp, harga: harga),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

class NotaPage extends StatefulWidget {
  const NotaPage({super.key});

  @override
  State<NotaPage> createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {
  late Future futureNota;

  @override
  void initState() {
    super.initState();
    futureNota = fetchNota();
  }

  Future<void> _editNotaPage(BuildContext context, Object? arguments) async {
    final result = await Navigator.pushNamed(
      context,
      '/notacounta',
      arguments: arguments,
    );

    if (result == 'OK') {
      setState(() {
        futureNota = fetchNota();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nota Page")),
      body: Center(
        child: FutureBuilder(
          future: futureNota,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return Text(snapshot.data.toString());
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final nota = Nota.fromJson(snapshot.data[index]);
                  return ListTile(
                    title: Text(nota.nama),
                    subtitle: Text(nota.noHp),
                    onTap: () {
                      _editNotaPage(context, nota);
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editNotaPage(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}




//CODING KEDUA
// class Nota {
//   final int? id;
//   final DateTime tanggal;
//   final String nama;
//   final String typeHp;
//   final String kerusakan;
//   final String kelengkapan;
//   final String noHp;
//   final double harga;

//   Nota({
//     this.id,
//     required this.tanggal,
//     required this.nama,
//     required this.typeHp,
//     required this.kerusakan,
//     required this.kelengkapan,
//     required this.noHp,
//     required this.harga,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'tanggal': tanggal.toIso8601String(),
//       'nama': nama,
//       'type_hp': typeHp,
//       'kerusakan': kerusakan,
//       'kelengkapan': kelengkapan,
//       'no_hp': noHp,
//       'harga': harga,
//     };
//   }

//   factory Nota.fromMap(Map<String, dynamic> map) {
//     return Nota(
//       id: map['id'] as int,
//       tanggal: DateTime.parse(map['tanggal']),
//       nama: map['nama'],
//       typeHp: map['type_hp'],
//       kerusakan: map['kerusakan'],
//       kelengkapan: map['kelengkapan'],
//       noHp: map['no_hp'],
//       harga: (map['harga'] as num).toDouble(),
//     );
//   }
// }






//coding awal

// class Nota {
//   final int? id;
//   final DateTime tanggal; // Tanggal nota tercatat.
//   final String nama; // Nama pemilik atau pelanggan.
//   final String typeHp; // Tipe handphone yang diperbaiki.
//   final String kerusakan; // Deskripsi kerusakan handphone.
//   final String kelengkapan; // Keterangan kelengkapan yang diserahkan.
//   final String noHp; // Nomor handphone pelanggan.
//   final double harga;
//   Nota({
//       required this.id,
//       required this.tanggal,
//       required this.nama,
//       required this.typeHp,
//       required this.kerusakan,
//       required this.kelengkapan,
//       required this.noHp,
//       required this.harga});
  

// //convert from Map
//   factory Nota.fromMap(Map<String, dynamic> map) {
//     return Nota(
//       id: map['id'],
//       tanggal: map['tanggal'] != null
//           ? DateTime.parse(map['tanggal'])
//           : DateTime.now(),
//       nama: map['nama'],
//       typeHp: map['typeHp'],
//       kerusakan: map['kerusakan'],
//       kelengkapan: map['kelengkapan'],
//       noHp: map['noHp'],
//       harga: map['harga'],
//     );
//   }

//   //convert to Map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'taggal': tanggal,
//       'nama': nama,
//       'typeHp': typeHp,
//       'kerusakan': kerusakan,
//       'kelengkapan': kelengkapan,
//       'noHp': noHp,
//       'harga': harga,
//     };
//   }
// }

