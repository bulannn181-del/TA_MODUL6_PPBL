import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorit_cubit.dart';
import '../cubit/pengajuan_cubit.dart';
import '../widgets/theme_toggle_button.dart';
import 'halaman_layanan.dart';

class HalamanWarga extends StatelessWidget {
  const HalamanWarga({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan Warga'),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Layanan Favorit',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          BlocBuilder<FavoritCubit, Set<String>>(
            builder: (context, favorit) {
              if (favorit.isEmpty) {
                return const Card(
                  child: ListTile(
                    title: Text('Belum ada layanan favorit.'),
                  ),
                );
              }

              return Column(
                children: favorit.map((nama) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.star, color: Colors.amber),
                      title: Text(nama),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          context.read<FavoritCubit>().toggle(nama);
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Daftar Pengajuan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          BlocBuilder<PengajuanCubit, List<String>>(
            builder: (context, pengajuan) {
              if (pengajuan.isEmpty) {
                return const Card(
                  child: ListTile(
                    title: Text('Belum ada pengajuan layanan.'),
                  ),
                );
              }

              return Column(
                children: [
                  ...List.generate(pengajuan.length, (index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text(pengajuan[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            context.read<PengajuanCubit>().hapus(index);
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<PengajuanCubit>().kirimSemua();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pengajuan berhasil dikirim.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Kirim Semua Pengajuan'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Layanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Warga',
          ),
        ],
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HalamanLayanan(),
              ),
            );
          }
        },
      ),
    );
  }
}