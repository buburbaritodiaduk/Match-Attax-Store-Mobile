1. Perbedaan Navigator.push() dan Navigator.pushReplacement()
    Perbedaan utamanya ada di cara Flutter mengelola stack halaman.
        Navigator.push() akan menumpuk halaman baru di atas halaman yang sekarang. Halaman lama masih ada di bawahnya, dan kita bisa kembali ke halaman itu (biasanya ada tombol back di AppBar).
        Ini dipakai saat menekan tombol "Create Product" di halaman utama. Tujuannya agar setelah di halaman form, pengguna bisa menekan tombol back dan kembali ke halaman utama.

        Navigator.pushReplacement() akan mengganti halaman yang sekarang dengan halaman baru. Halaman yang lama akan dibuang dari tumpukan. Karena halaman lama dibuang, kita tidak bisa kembali ke halaman tersebut (tombol back tidak akan muncul).
        Ini dipakai di dalam LeftDrawer. Tujuannya agar waktu pengguna pindah-pindah halaman lewat drawer (misal dari Home ke Create Product), tumpukan halamannya tidak menumpuk. Ini mencegah pengguna menekan back berkali-kali hanya karena membuka halaman yang sama dari drawer.

2. Manfaat Hirarki Widget (Scaffold, AppBar, Drawer)
    Ketiga widget ini adalah fondasi untuk membangun struktur halaman yang konsisten di seluruh aplikasi. Penggunaan hirarki ini membuat UI aplikasi jadi mudah dikenali dan navigasinya jelas bagi pengguna.
        - Scaffold: dipakai sebagai kerangka dasar di setiap halaman baru (menu.dart dan product_form.dart). Scaffold menyediakan slot standar untuk AppBar, body, dan Drawer.
        - AppBar: Dengan menaruh AppBar di Scaffold, ini dapat memastikan setiap halaman punya judul yang konsisten di bagian atas.
        - Drawer: Pada project, drawer digunakan untuk membuat satu widget khusus di LeftDrawer. Widget ini dipanggil di setiap Scaffold (drawer: const LeftDrawer()). Hasilnya, semua halaman jadi punya menu navigasi samping yang identik, baik tampilan maupun fungsinya.

3. Kelebihan Layout Widget di Form (Padding SingleChildScrollView)
    Widget tata letak ini sangat penting agar formulir mudah digunakan dan tidak berantakan.
    - Padding: Padding dipakai untuk membungkus setiap elemen input (seperti TextFormField atau DropdownButtonFormField). Kelebihannya jelas: memberi jarak antar elemen dan antara elemen dengan pinggir layar. Tanpa Padding, semua input akan menempel satu sama lain dan terlihat sempit.
    - SingleChildScrollView Ini adalah widget krusial untuk form SingleChildScrollView dipakai untuk membungkus seluruh Column yang berisi elemen-elemen form. Kelebihannya: saat keyboard HP muncul untuk mengisi input di bagian bawah, halaman bisa di-scroll. Ini mencegah error Bottom Overflow (tampilan kuning-hitam) yang terjadi saat konten tidak muat di layar.

4. Penyesuaian Warna Tema
    Untuk membuat identitas visual yang konsisten (di aplikasi ini saya menganut tema monokrom), saya tidak mengatur warna satu per satu di setiap widget seperti AppBar(backgroundColor: Colors.grey).

    Cara yang dipake:
    Definisi Tema Terpusat: Saya mengatur ThemeData di file main.dart, di dalam properti theme pada MaterialApp.
    Atur colorScheme dan Komponen: Di dalam ThemeData, saya mengatur colorScheme (misal primarySwatch: Colors.grey), appBarTheme (warna AppBar), dan elevatedButtonTheme (warna tombol).
    Panggil Warna Tema: Di halaman lain (seperti product_form.dart), saya menggunakan warna dari tema tersebut, contoh: backgroundColor: Theme.of(context).appBarTheme.backgroundColor.
    Kelebihannya, jika suatu saat saya ingin mengubah branding (misal dari monokrom menjadi hijau), saya cukup mengubah warna di satu tempat (main.dart), dan seluruh tampilan AppBar, tombol, dan komponen lain di aplikasi akan otomatis ikut berubah.