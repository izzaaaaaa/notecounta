import 'package:supabase_flutter/supabase_flutter.dart';

Future fetchNote() async {
  final supabase = Supabase.instance.client;

  final data = await supabase.from('nota_konter').select();
  return data;
}

class Nota {
  final int? id;
  final DateTime tanggal; // Tanggal nota tercatat.
  final String nama; // Nama pemilik atau pelanggan.
  final String typeHp; // Tipe handphone yang diperbaiki.
  final String kerusakan; // Deskripsi kerusakan handphone.
  final String kelengkapan; // Keterangan kelengkapan yang diserahkan.
  final String noHp; // Nomor handphone pelanggan.
  final double harga;
  Nota({
      required this.id,
      required this.tanggal,
      required this.nama,
      required this.typeHp,
      required this.kerusakan,
      required this.kelengkapan,
      required this.noHp,
      required this.harga});
  

//convert from Map
  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'],
      tanggal: map['tanggal'] != null
          ? DateTime.parse(map['tanggal'])
          : DateTime.now(),
      nama: map['nama'],
      typeHp: map['typeHp'],
      kerusakan: map['kerusakan'],
      kelengkapan: map['kelengkapan'],
      noHp: map['noHp'],
      harga: map['harga'],
    );
  }

  //convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taggal': tanggal,
      'nama': nama,
      'typeHp': typeHp,
      'kerusakan': kerusakan,
      'kelengkapan': kelengkapan,
      'noHp': noHp,
      'harga': harga,
    };
  }
}

