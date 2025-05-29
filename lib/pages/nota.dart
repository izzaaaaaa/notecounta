import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Nota extends StatefulWidget {
  final Map<String, dynamic>? notaData; // Data yang dikirim untuk mode edit

  const Nota({super.key, this.notaData});

  @override
  State<Nota> createState() => _NotaState();
}
class _NotaState extends State<Nota> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _typeHpController;
  late TextEditingController _kerusakanController;
  late TextEditingController _kelengkapanController;
  late TextEditingController _noHpController;
  late TextEditingController _hargaController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.notaData?['nama'] ?? '');
    _typeHpController = TextEditingController(text: widget.notaData?['type_hp'] ?? '');
    _kerusakanController = TextEditingController(text: widget.notaData?['kerusakan'] ?? '');
    _kelengkapanController = TextEditingController(text: widget.notaData?['kelengkapan'] ?? '');
    _noHpController = TextEditingController(text: widget.notaData?['no_hp'] ?? '');
    _hargaController = TextEditingController(text: widget.notaData?['harga']?.toString() ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _typeHpController.dispose();
    _kerusakanController.dispose();
    _kelengkapanController.dispose();
    _noHpController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> saveNota() async {
    if (_formKey.currentState!.validate()) {
      final notaData = {
        'nama': _namaController.text,
        'type_hp': _typeHpController.text,
        'kerusakan': _kerusakanController.text,
        'kelengkapan': _kelengkapanController.text,
        'no_hp': _noHpController.text,
        'harga': double.tryParse(_hargaController.text) ?? 0.0,
      };

      if (widget.notaData == null) {
        // Tambah nota baru
        await Supabase.instance.client.from('nota_konter').insert(notaData);
      } else {
        // Update nota yang sudah ada
        await Supabase.instance.client.from('nota_konter').update(notaData).eq('id', widget.notaData!['id']);
      }

      Navigator.pop(context, 'OK');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notaData == null ? 'Tambah Nota' : 'Edit Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
              
            )
          )
        )
      )

      ),