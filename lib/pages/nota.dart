import 'package:flutter/material.dart'; // Untuk UI
import 'package:intl/intl.dart'; // Untuk format tanggal & angka
import 'package:supabase_flutter/supabase_flutter.dart'; // Untuk koneksi Supabase

class Nota extends StatefulWidget {
  final Map<String, dynamic>? notaData; // Data yang dikirim untuk mode edit

  const Nota({super.key, this.notaData});

  @override
  State<Nota> createState() => _NotaState();
} 

class _NotaState extends State<Nota> {
  final supabase = Supabase.instance.client; // Koneksi Supabase

  final _formKey = GlobalKey<FormState>(); // Kunci form untuk validasi
  DateTime? _selectedDate; // Menyimpan tanggal nota
  final _namaController = TextEditingController(); // Input nama
  final _typeHpController = TextEditingController(); // Input tipe HP
  final _kerusakanController = TextEditingController(); // Input kerusakan
  final _kelengkapanController = TextEditingController(); // Input kelengkapan
  final _noHpController = TextEditingController(); // Input no HP
  final _hargaController = TextEditingController(); // Input harga

  final DateFormat _dateFormat = DateFormat('dd - MM - yyyy'); // Format tampilan tanggal

  @override
  void initState() {
    super.initState();
    if (widget.notaData != null) {
      // Jika dalam mode edit, isi semua field dari data
      final data = widget.notaData!;
      _selectedDate = DateTime.parse(data['tanggal']);
      _namaController.text = data['nama'] ?? '';
      _typeHpController.text = data['type_hp'] ?? '';
      _kerusakanController.text = data['kerusakan'] ?? '';
      _kelengkapanController.text = data['kelengkapan'] ?? '';
      _noHpController.text = (data['no_hp'] ?? '').toString();
      _hargaController.text = (data['harga'] != null)
          ? NumberFormat('#,###', 'id_ID').format(data['harga']).replaceAll(',', '.')
          : '';
    } else {
      _selectedDate = DateTime.now(); // Jika tambah baru, set tanggal hari ini
    }
  }

  // Fungsi untuk memformat harga jadi "12.000"
  String formatHargaOutput(String input) {
    final onlyDigits = input.replaceAll(RegExp(r'[^0-9]'), ''); // Hanya angka
    if (onlyDigits.isEmpty) return '';
    double number = double.parse(onlyDigits);
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(number).replaceAll(',', '.'); // Format ke ribuan
  }

  // Fungsi saat tombol submit ditekan
  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return; // Jika form tidak valid, keluar
    if (_selectedDate == null) {
    }

    // Persiapkan data untuk disimpan
    final data = {
      'tanggal': _selectedDate!.toIso8601String().split('T').first, // Format YYYY-MM-DD
      'nama': _namaController.text.trim(),
      'type_hp':_typeHpController.text.trim(),
      'kerusakan': _kerusakanController.text.trim(),
      'kelengkapan': _kelengkapanController.text.trim(),
      'no_hp': int.parse(_noHpController.text.trim()),
      'harga': double.parse(_hargaController.text.trim().replaceAll('.', '')), // Hapus titik sebelum parse
    };

    final id = widget.notaData?['id']; // Ambil ID jika mode edit

    try {
      if (id == null) {
        await supabase.from('nota_konter').insert(data); // Tambah data baru
      } else {
        await supabase.from('nota_konter').update(data).eq('id', id); // Update data lama
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(id == null
              ? 'Data berhasil ditambahkan.'
              : 'Data berhasil diperbarui.'),
        ),
      );
      Navigator.pop(context, true); // Kembali ke halaman sebelumnya
    } catch (e) {
      // Jika gagal menyimpan data
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Hapus controller saat widget dibuang
    _namaController.dispose();
    _typeHpController.dispose();
    _kerusakanController.dispose();
    _kelengkapanController.dispose();
    _noHpController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.notaData == null ? 'Tambah Nota' : 'Edit Nota'; // Judul AppBar

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Padding di seluruh form
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Field tanggal (readonly)
              TextFormField(
                readOnly: true, // Tidak bisa diketik manual
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : _dateFormat.format(_selectedDate!),
                ),
              ),
              const SizedBox(height: 12),

              // Input nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input type HP
              TextFormField(
                controller: _typeHpController,
                decoration: const InputDecoration(
                  labelText: 'Type HP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Type HP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input kerusakan
              TextFormField(
                controller: _kerusakanController,
                decoration: const InputDecoration(
                  labelText: 'Kerusakan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kerusakan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input kelengkapan
              TextFormField(
                controller: _kelengkapanController,
                decoration: const InputDecoration(
                  labelText: 'Kelengkapan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kelengkapan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input no HP
              TextFormField(
                controller: _noHpController,
                decoration: const InputDecoration(
                  labelText: 'No HP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'No HP tidak boleh kosong';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'No HP harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Input harga
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ', // Tambahkan prefix "Rp"
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final formatted = formatHargaOutput(value); // Format saat diketik
                  if (formatted != value) {
                    _hargaController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  final numberStr = value.replaceAll('.', '');
                  if (double.tryParse(numberStr) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(widget.notaData == null ? Icons.add : Icons.save),
                  label: Text(widget.notaData == null ? 'Tambah' : 'Simpan'),
                  onPressed: submitForm, // Jalankan fungsi submit
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
