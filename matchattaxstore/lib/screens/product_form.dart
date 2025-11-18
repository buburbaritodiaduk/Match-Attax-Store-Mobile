import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:matchattaxstore/screens/menu.dart';
import 'package:matchattaxstore/widgets/left_drawer.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Variabel state untuk menampung data dari form
  String _name = "";
  double _price = 0.0;
  String _description = "";
  String _thumbnail = "";
  String _category = "base"; 
  bool _isFeatured = false; 

  // Opsi untuk dropdown Kategori
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
    // 1. Tambahkan CookieRequest di sini
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Create New Product',
          ),
        ),
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

                // Input Harga Produk
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
                        return "Harga harus berupa angka!";
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
                    maxLines: 3,
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

                // Input URL Thumbnail
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
                      if (!_isValidUrl(value)) {
                        return "URL tidak valid (harus diawali http:// atau https://)";
                      }
                      return null;
                    },
                  ),
                ),

                // Input Kategori
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Kategori",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    value: _category,
                    items: _categoryOptions.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                  ),
                ),

                // Input Is Featured
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
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                // Tombol Save (UPDATED)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          
                          // Kirim ke Django dan tunggu respons
                          // GANTI URL: Gunakan http://10.0.2.2:8000/create-flutter/ jika pakai Android Emulator
                          // Gunakan http://127.0.0.1:8000/create-flutter/ jika pakai Chrome
                          final response = await request.postJson(
                            "http://127.0.0.1:8000/create-flutter/",
                            jsonEncode({
                              "name": _name,
                              "price": _price.toInt(), // Pastikan Django terima Integer, hapus .toInt() jika butuh Double
                              "description": _description,
                              "thumbnail": _thumbnail,
                              "category": _category,
                              "is_featured": _isFeatured,
                            }),
                          );
                          
                          if (context.mounted) {
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Product successfully saved!"),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MyHomePage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Something went wrong, please try again."),
                                ),
                              );
                            }
                          }
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