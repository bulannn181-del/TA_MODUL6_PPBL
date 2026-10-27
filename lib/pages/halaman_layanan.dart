import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorit_cubit.dart';
import '../widgets/theme_toggle_button.dart';
import 'halaman_detail_layanan.dart';
import 'halaman_warga.dart';

class HalamanLayanan extends StatelessWidget {
  const HalamanLayanan({super.key});

  static const List<Map<String, String>> layanan = [
    {
      'nama': 'Pembuatan KTP',
      'kategori': 'Perizinan',
      'dinas': 'Dinas Kependudukan',
      'jam': '08.00 - 15.00',
      'keterangan': 'Layanan pembuatan dan perpanjangan KTP.',
    },
    {
      'nama': 'Layanan Puskesmas',
      'kategori': 'Kesehatan',
      'dinas': 'Dinas Kesehatan',
      'jam': '07.00 - 14.00',
      'keterangan': 'Informasi dan pengajuan layanan kesehatan.',
    },
    {
      'nama': 'Bus Kota',
      'kategori': 'Transportasi',
      'dinas': 'Dinas Perhubungan',
      'jam': '06.00 - 21.00',
      'keterangan': 'Informasi rute dan layanan transportasi kota.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nusantara Cerdas'),
          actions: const [ThemeToggleButton()],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Perizinan'),
              Tab(text: 'Kesehatan'),
              Tab(text: 'Transportasi'),
            ],
          ),
        ),
        body: TabBarView(
          children: ['Perizinan', 'Kesehatan', 'Transportasi']
              .map((kategori) {
            final daftar = layanan
                .where((item) => item['kategori'] == kategori)
                .toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  kategori,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...daftar.map((item) {
                  final nama = item['nama']!;

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.miscellaneous_services),
                      ),
                      title: Text(nama),
                      subtitle: Text(item['dinas']!),
                      trailing: BlocBuilder<FavoritCubit, Set<String>>(
                        builder: (context, favorit) {
                          final aktif = favorit.contains(nama);

                          return IconButton(
                            icon: Icon(
                              aktif ? Icons.star : Icons.star_border,
                              color: aktif ? Colors.amber : null,
                            ),
                            onPressed: () {
                              context.read<FavoritCubit>().toggle(nama);
                            },
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HalamanDetailLayanan(
                              namaLayanan: nama,
                              dinas: item['dinas']!,
                              jamOperasional: item['jam']!,
                              keterangan: item['keterangan']!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
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
            if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HalamanWarga(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}