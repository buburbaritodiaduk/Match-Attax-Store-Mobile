1. Jelaskan mengapa kita perlu membuat model Dart saat mengambil/mengirim data JSON? Apa konsekuensinya jika langsung memetakan Map<String, dynamic> tanpa model (terkait validasi tipe, null-safety, maintainability)?

Kita perlu membuat Model Dart (berupa class dengan constructor dan factory) saat mengambil atau mengirim data JSON untuk menjaga kualitas kode.
    Tipe Safety & Null-Safety
        - Dengan Model: Kita menjamin bahwa setiap variabel memiliki tipe data yang pasti (String, int, bool, dll.). Kompiler Dart dapat langsung mendeteksi kesalahan (misalnya mencoba memasukkan string ke dalam integer) saat compile time, bukan saat aplikasi berjalan (runtime error).
        - Tanpa Model (Map<String, dynamic>): Data yang diambil dari JSON hanyalah    tipe dynamic. Kamu harus melakukan casting secara manual (data['price'] as int), yang rawan runtime error jika data dari server tiba-tiba berubah tipe (misal: harga dikirim sebagai string "100" padahal di Flutter diharapkan integer).

    Konsekuensi Tanpa Model
        - Maintainability Rendah: Jika struktur JSON berubah, kamu harus mencari dan memperbaiki setiap baris kode di seluruh aplikasi yang menggunakan key tersebut.
        - Null-Safety Buruk: Kamu tidak bisa mendefinisikan field mana yang wajib (non-nullable) dan mana yang opsional dengan jelas, meningkatkan risiko kesalahan null yang tidak terduga.

2. Apa fungsi package http dan CookieRequest dalam tugas ini? Jelaskan perbedaan peran http vs CookieRequest.
    Perbedaan Peran: http adalah alat komunikasi umum. CookieRequest adalah agen otentikasi yang bertugas menjaga status login antara klien Flutter dan server Django.  
        - http: Melakukan operasi dasar HTTP (GET, POST, PUT, DELETE). Fondasi, digunakan di balik layar oleh CookieRequest.

        - CookieRequest: Merupakan wrapper di atas http yang spesifik untuk otentikasi berbasis session. Otomatis menyimpan cookie session dari Django setelah login dan mengirimkan cookie tersebut di setiap permintaan berikutnya.

3. Jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.

    CookieRequest harus dibagikan ke semua komponen aplikasi menggunakan Provider karena:
        - Status Login Global: Session ID (berupa cookie) yang didapatkan saat login harus diakses oleh seluruh halaman (misal: halaman utama, form produk, dll.). Setiap halaman yang ingin berinteraksi dengan Django perlu membuktikan bahwa pengguna sudah terotentikasi.

        - Maintain Status: CookieRequest adalah state yang menyimpan status isLoggedIn dan cookie itu sendiri. Jika instance ini dibuat berulang kali, cookie session yang baru didapat akan hilang, dan pengguna akan dianggap logout di setiap pindah halaman.

        - Kemudahan Akses: Dengan Provider, kita bisa mengakses instance CookieRequest dari widget mana pun menggunakan context.watch<CookieRequest>() tanpa harus meneruskannya secara manual.

4. Jelaskan konfigurasi konektivitas yang diperlukan agar Flutter dapat berkomunikasi dengan Django. Mengapa kita perlu menambahkan 10.0.2.2 pada ALLOWED_HOSTS, mengaktifkan CORS dan pengaturan SameSite/cookie, dan menambahkan izin akses internet di Android? Apa yang akan terjadi jika konfigurasi tersebut tidak dilakukan dengan benar?

    - 10.0.2.2 pada URL 
    Alasan perlu: Ini adalah alias IP khusus di Android Emulator yang merujuk ke mesin host (komputer) tempat Django berjalan.
    Konsekuensi: Emulator tidak dapat menemukan server Django (Connection refused atau timeout).

    - 10.0.2.2 pada ALLOWED_HOSTS
    Alasan perlu: Django secara default memblokir akses dari alamat IP asing. Kita perlu secara eksplisit mengizinkan 10.0.2.2 dan 127.0.0.1 (untuk Chrome) agar server merespons permintaan.
    Konsekuensi: Server mengembalikan error 400 Bad Request saat request masuk.

    - django-cors-headers (CORS)
    Alasan perlu: Browser (saat Flutter berjalan di Chrome/Web) memblokir permintaan lintas-domain (beda port) dari Flutter ke Django.
    Konsekuensi: Request diblokir oleh browser sebelum sampai ke Django 

    - Pengaturan SameSite/Cookie
    Alasan oerlu: Diperlukan agar browser atau aplikasi Android mengizinkan session cookie dikirim kembali ke Django.
    Konsekuensi: Status login tidak bisa dipertahankan. Pengguna akan dianggap logout setiap kali pindah halaman atau refresh.

    - Izin Internet Android
    Alasan perlu: Aplikasi Android memerlukan izin eksplisit (<uses-permission>) di AndroidManifest.xml untuk dapat mengakses jaringan.
    Konsekuensi: Aplikasi gagal melakukan koneksi HTTP/HTTPS dan crash atau silent fail saat mencoba request (khususnya di HP fisik).

5.  Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.
    - Input dan Validasi (Flutter): Pengguna mengisi form. Saat tombol "Simpan" ditekan, _formKey.currentState!.validate() memastikan semua field valid.
    - JSON Encoding (Flutter): Data dari state (_name, _price, dll.) dipaketkan ke dalam Map dan diubah menjadi string JSON menggunakan jsonEncode().
    - Request (Flutter): request.postJson() mengirim string JSON tersebut ke endpoint Django (misal: /create-flutter/). Cookie session otomatis disertakan.
    - Parsing dan Pemrosesan (Django): Fungsi create_product_flutter menerima POST request, memverifikasi cookie (menentukan request.user), memproses JSON dengan json.loads(request.body), dan membuat objek Product.
    - Respons (Django): Server mengirim kembali JsonResponse dengan status {"status": "success"}.
    - Display (Flutter): Flutter menerima respons. Jika response['status'] == 'success', aplikasi menampilkan SnackBar sukses dan menavigasi ke halaman utama (MyHomePage).

6. Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.

    A. Login dan Register
    1. Input (Flutter): Pengguna memasukkan username dan password di LoginPage atau RegisterPage.
    2. Request (Flutter):
    3. Login: Menggunakan await request.login(url, data_map). Data dikirim sebagai Form Data atau Map biasa.
    4. Register: Menggunakan await request.postJson(url, json_string). Data dikirim sebagai JSON.
    5. Verifikasi (Django): Django menerima request.
    6. Login: Fungsi authenticate() memverifikasi credentials. Jika valid, auth_login(request, user) membuat session baru.
    7. Register: Fungsi membuat objek User baru, menyimpan ke database.
    8. Respon (Django): Server mengirim respons sukses (200 OK). Yang terpenting, session ID dikirim ke klien dalam bentuk cookie.
    9. Penyimpanan Cookie (Flutter): CookieRequest menangkap cookie session ini dan menyimpannya secara internal. Status request.loggedIn menjadi true.
    10. Navigasi (Flutter): Aplikasi menavigasi ke halaman menu (MyHomePage).

    B. Logout
    1. Tekan toimbol (Flutter): Pengguna menekan tombol "Logout" di ItemCard.
    2. Request (Flutter): await request.logout(url) dikirim sebagai POST request ke endpoint /auth/logout/.
    3. Penghapusan Session (Django): Fungsi logout(request) menghapus session ID dari database server.
    4. Respon dan Reset (Flutter): Django merespons sukses. CookieRequest secara internal menghapus cookie yang tersimpan dan mereset status request.loggedIn menjadi false.
    5. Navigasi: Aplikasi diarahkan kembali ke LoginPage (Navigator.pushReplacement).

7. Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).

    1. Saya memulai dengan menyiapkan Model Product di Django dan mengimplementasikan semua view yang diperlukan (autentikasi, CRUD data).
    Konektivitas: Saya mengatur CORS di settings.py dan menambahkan IP 10.0.2.2 ke ALLOWED_HOSTS.
    2. Fondasi Flutter 
    Kemudian, Saya membuat class Model Dart untuk Product. Ini menjamin type safety saat memproses data JSON dari server.
    Provider: Saya membagikan instance CookieRequest ke seluruh aplikasi menggunakan Provider. Tujuannya adalah agar cookie session dapat diakses dan digunakan oleh setiap komponen yang memerlukan otentikasi.
    3. Otentikasi dan Data
    Login/Register: Saya membuat LoginPage dan RegisterPage. Untuk mengirim credentials, saya menggunakan:
    Logout: Saya mengimplementasikan fungsi request.logout pada tombol menu, yang akan menghapus sesi dan mengarahkan kembali ke halaman login.
    Form Produk: Di ProductFormPage, saya menggunakan request.postJson untuk mengirim data form produk (name, price, dll.) ke Django.
    4. Penyesuaian Lingkungan
    Semua request saya arahkan ke URL yang benar (misalnya http://127.0.0.1:8000/ untuk Chrome atau http://10.0.2.2:8000/ untuk Emulator) agar proses debugging berjalan lancar di berbagai lingkungan.
