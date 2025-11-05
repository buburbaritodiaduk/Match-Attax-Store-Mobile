Berikut versi jawabannya dengan gaya mahasiswa:
1. Widget treeDi Flutter, semua tampilan disusun dalam bentuk pohon yang disebut widget tree. Setiap elemen di layar adalah widget. Widget yang membungkus widget lain disebut parent, dan yang dibungkus disebut child. Misalnya, Scaffold jadi parent dari AppBar, Body, dan FloatingActionButton. Jadi hubungan antar widget itu kayak hirarki dari atas ke bawah.

2. Widget yang gua pakai di proyek ini
    MaterialApp: Buat ngatur tema dan route aplikasi.
    Scaffold: Rangka utama halaman, tempat naro AppBar, Body, dan FloatingActionButton.
    AppBar: Nampilin judul di atas aplikasi.
    Text: Buat nampilin teks.
    Column dan Row: Nyusun widget secara vertikal atau horizontal.
    Container: Buat ngatur posisi, warna, dan ukuran.
    ElevatedButton: Tombol yang bisa ditekan.
    Icon: Buat nampilin ikon.

3. Fungsi MaterialApp dan kenapa dijadiin rootMaterialApp itu kayak fondasi utama aplikasi Flutter. Dia nyediain tema, navigasi, dan style bawaan Material Design. Biasanya dijadiin root biar semua widget di bawahnya bisa akses hal-hal kayak tema atau route dengan mudah.

4. Perbedaan StatelessWidget dan StatefulWidget
    StatelessWidget: Gak punya data yang bisa berubah. Cocok buat tampilan statis.
    StatefulWidget: Bisa nyimpen dan ubah data di dalam state. Cocok buat tampilan yang dinamis, misalnya counter atau input user.Gua pakai StatefulWidget kalau ada interaksi user atau data yang berubah.

5. BuildContextBuildContext itu semacam identitas posisi widget di dalam widget tree. Dipakai buat ngambil data dari widget parent, kayak tema atau navigasi. Misalnya di build(), kita bisa tulis Theme.of(context) atau Navigator.of(context).push() buat pindah halaman.

6. Hot reload vs hot restart
    Hot reload: Nge-update kode tanpa ngilangin state. Cocok buat ubah tampilan atau teks cepet.
    Hot restart: Ngerestart seluruh aplikasi dan nge-reset semua state. Biasanya dipakai kalau ubah struktur utama aplikasi atau variabel global.
