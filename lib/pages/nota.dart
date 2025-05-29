import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Nota extends StatefulWidget {
  final Map<String, dynamic>? notaData; // Data yang dikirim untuk mode edit

  const Nota({super.key, this.notaData});

  @override
  State<Nota> createState() => _NotaState();
}
class _NotaState extends State<Nota> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.notaData != null) {
      // Jika ada data nota, isi controller dengan data tersebut
      _namaController.text = widget.notaData!['nama'] ?? '';
      _nomorController.text = widget.notaData!['nomor'] ?? '';
      _jumlahController.text = widget.notaData!['jumlah']?.toString() ?? '';
      _hargaController.text = widget.notaData!['harga']?.toString() ?? '';
      _totalController.text = widget.notaData!['total']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nomorController.dispose();
    _jumlahController.dispose();
    _hargaController.dispose();
    _totalController.dispose();
    super.dispose();
  }