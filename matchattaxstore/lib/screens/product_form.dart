// Lokasi file: lib/screens/product_form.dart

import 'package:flutter/material.dart';
import 'package:matchattaxstore/widgets/left_drawer.dart'; // Pastikan path ini benar

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Variabel state untuk menampung data dari form
  String _name = "";
  double _price = 0.0; // Diubah menjadi double (FloatField)
  String _description = "";
  String _thumbnail = ""; // Ditambah
  String _category = "base"; // Ditambah (default value dari model)
  bool _isFeatured = false; // Ditambah

  // Opsi untuk dropdown Kategori, sesuai CATEGORY_CHOICES di model
  // Kita gunakan Map<String, String> untuk menyimpan 'value' dan 'display_name'
  final Map<String, String> _categoryOptions = {
    'base': 'Base Card',
    'man_of_the_match': 'Man of the Match',
    'club_legend': 'Club Legend',
    'rising_star': 'Rising Star',
    '100_club': '100 Club',
    'limited_edition': 'Limited Edition',
    'signature_style': 'Signature Style',
    'hat_trick_hero': 'Hat-Trick Hero',
    'captain': 'Captain',
    'trophy_card': 'Trophy Card',
  };

  // Fungsi helper untuk validasi URL
  bool _isValidUrl(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      return false;
    }
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Create New Product',
          ),
        ),
        // Menggunakan warna tema monokrom
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Nama Produk
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Nama Produk",
                      labelText: "Nama Produk",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _name = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Nama tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),

                // Input Harga Produk (diubah ke double)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Harga",
                      labelText: "Harga",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (String? value) {
                      setState(() {
                        _price = double.tryParse(value!) ?? 0.0;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Harga tidak boleh kosong!";
                      }
                      if (double.tryParse(value) == null) {
                        return "Harga harus berupa angka (contoh: 50000.0)!";
                      }
                      if (double.tryParse(value)! <= 0) {
                        return "Harga harus lebih dari nol!";
                      }
                      return null;
                    },
                  ),
                ),

                // Input Deskripsi Produk
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Deskripsi",
                      labelText: "Deskripsi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    maxLines: 3, // TextField di Django, jadi bisa multi-baris
                    onChanged: (String? value) {
                      setState(() {
                        _description = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Deskripsi tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),

                // BARU: Input URL Thumbnail
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Contoh: https://example.com/image.png",
                      labelText: "URL Thumbnail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _thumbnail = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "URL Thumbnail tidak boleh kosong!";
                      }
                      // Validasi format URL (sesuai permintaan tugas)
                      if (!_isValidUrl(value)) {
                        return "URL tidak valid (harus diawali http:// atau https://)";
                      }
                      return null;
                    },
                  ),
                ),

                // BARU: Input Kategori (Dropdown)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Kategori",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    value: _category, // Nilai default
                    items: _categoryOptions.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key, // 'base'
                        child: Text(entry.value), // 'Base Card'
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                  ),
                ),

                // BARU: Input Is Featured (Switch)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SwitchListTile(
                    title: const Text("Tandai sebagai Unggulan"),
                    value: _isFeatured,
                    onChanged: (bool value) {
                      setState(() {
                        _isFeatured = value;
                      });
                    },
                    // Atur warna switch agar sesuai tema monokrom
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                // Tombol Save
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      // Menggunakan style dari tema
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Tampilkan pop-up dengan SEMUA data
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Produk berhasil tersimpan'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nama: $_name'),
                                      Text('Harga: $_price'),
                                      Text('Deskripsi: $_description'),
                                      Text('Thumbnail: $_thumbnail'),
                                      Text('Kategori: $_category'),
                                      Text('Unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          
                          // Reset form
                          _formKey.currentState!.reset();
                          // Reset state variabel ke default
                          setState(() {
                             _name = "";
                             _price = 0.0;
                             _description = "";
                             _thumbnail = "";
                             _category = "base";
                             _isFeatured = false;
                          });
                        }
                      },
                      child: const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}