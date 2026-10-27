import 'package:flutter_bloc/flutter_bloc.dart';

class PengajuanCubit extends Cubit<List<String>> {
  PengajuanCubit() : super(<String>[]);

  int get totalPengajuan => state.length;

  void tambah(String namaLayanan) {
    emit([...state, namaLayanan]);
  }

  void hapus(int index) {
    if (index < 0 || index >= state.length) return;

    final daftarBaru = [...state];
    daftarBaru.removeAt(index);
    emit(daftarBaru);
  }

  void kirimSemua() {
    emit(<String>[]);
  }
}
