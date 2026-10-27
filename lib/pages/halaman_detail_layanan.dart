import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/pengajuan_cubit.dart';

class HalamanDetailLayanan extends StatefulWidget {
  final String namaLayanan;
  final String dinas;
  final String jamOperasional;
  final String keterangan;

  const HalamanDetailLayanan({
    super.key,
    required this.namaLayanan,
    required this.dinas,
    required this.jamOperasional,
    required this.keterangan,
  });

  @override
  State<HalamanDetailLayanan> createState() =>
      _HalamanDetailLayananState();
}

class _HalamanDetailLayananState extends State<HalamanDetailLayanan> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  bool sedangMengirim = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    super.dispose();
  }

  Future<void> _ajukanPermohonan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => sedangMengirim = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    context.read<PengajuanCubit>().tambah(widget.namaLayanan);

    setState(() => sedangMengirim = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengajuan berhasil ditambahkan.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Layanan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.account_balance,
            size: 64,
            color: Colors.teal,
          ),
          const SizedBox(height: 16),
          Text(
            widget.namaLayanan,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Dinas: ${widget.dinas}'),
          Text('Jam operasional: ${widget.jamOperasional}'),
          const SizedBox(height: 8),
          Text(widget.keterangan),
          const Divider(height: 32),
          Text(
            'Formulir Pengajuan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama lengkap',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nikController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NIK',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'NIK wajib diisi';
                    }
                    if (value.trim().length != 16) {
                      return 'NIK harus terdiri dari 16 angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed:
                        sedangMengirim ? null : _ajukanPermohonan,
                    icon: sedangMengirim
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(
                      sedangMengirim
                          ? 'Mengirim...'
                          : 'Ajukan Permohonan',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}