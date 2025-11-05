Berikut versi penjelasan yang lebih formal tapi tetap santai dan mudah dipahami:
1. Widget treeDalam Flutter, seluruh tampilan aplikasi tersusun dalam struktur hierarki yang disebut widget tree. Setiap elemen di layar merupakan sebuah widget. Widget yang membungkus widget lain disebut parent, sedangkan widget di dalamnya disebut child. Contohnya, Scaffold menjadi parent dari AppBar, Body, dan FloatingActionButton. Hubungan ini menunjukkan bagaimana elemen saling terhubung dan memengaruhi satu sama lain.

2. Widget yang digunakan dalam proyek ini
    MaterialApp: Mengatur tema, navigasi, dan konfigurasi dasar aplikasi.
    Scaffold: Menyediakan struktur utama halaman yang berisi AppBar, Body, dan FloatingActionButton.
    AppBar: Menampilkan judul atau aksi di bagian atas aplikasi.
    Text: Menampilkan teks pada layar.
    Column dan Row: Menyusun widget secara vertikal atau horizontal.
    Container: Mengatur ukuran, posisi, dan warna latar.
    ElevatedButton: Tombol interaktif dengan efek elevasi.
    Icon: Menampilkan ikon sesuai kebutuhan tampilan.
3. Fungsi MaterialApp dan alasan digunakan sebagai rootMaterialApp berfungsi sebagai pondasi utama aplikasi berbasis Material Design. Widget ini mengatur tema, warna, route, serta beberapa konfigurasi global lainnya. Biasanya digunakan sebagai widget root agar seluruh widget di bawahnya dapat mengakses konteks tema dan sistem navigasi dengan mudah.

4. Perbedaan StatelessWidget dan StatefulWidget
    StatelessWidget: Tidak memiliki state atau data yang dapat berubah. Cocok untuk tampilan statis seperti teks atau ikon.
    StatefulWidget: Memiliki state yang bisa berubah selama aplikasi berjalan. Cocok digunakan untuk tampilan dinamis seperti counter atau input pengguna.Pemilihan keduanya bergantung pada apakah tampilan memerlukan perubahan data atau tidak.

5. BuildContext dan penggunaannyaBuildContext merepresentasikan posisi widget di dalam widget tree. Objek ini penting untuk mengakses data dari widget parent, seperti tema, navigator, atau media query. Pada metode build(), context biasanya digunakan untuk memanggil fungsi seperti Theme.of(context) atau Navigator.of(context).push().

6. Hot reload dan hot restart
    Hot reload: Memperbarui kode dan langsung menampilkan perubahan tanpa menghapus state aplikasi. Umumnya digunakan untuk mempercepat proses pengembangan tampilan.
    Hot restart: Memuat ulang seluruh aplikasi dari awal dan menghapus seluruh state. Biasanya digunakan ketika terjadi perubahan besar pada struktur atau inisialisasi variabel global.
