import 'package:flutter/material.dart';
import 'package:matchattaxstore/screens/login.dart';
import 'package:matchattaxstore/screens/product_form.dart';
import 'package:matchattaxstore/screens/product_entry_list.dart'; // Pastikan import ini ada
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Menambahkan async agar bisa melakukan request logout
        onTap: () async {
          // Menampilkan pesan bahwa tombol ditekan
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));

          // Navigasi ke Create Product
          if (item.name == "Create Product") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductFormPage(),
                ));
          } 
          
          // Navigasi ke All Products (Daftar Produk)
          else if (item.name == "All Products") {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductEntryListPage(),
                ));
          }
          
          // LOGIKA LOGOUT
          else if (item.name == "Logout") {
            // Ganti URL di bawah ini:
            // Untuk Chrome/Web: http://127.0.0.1:8000/auth/logout/
            // Untuk Android Emulator: http://10.0.2.2:8000/auth/logout/
            final response = await request.logout(
                "http://127.0.0.1:8000/auth/logout/");
            
            String message = response['message'];
            
            if (context.mounted) {
              if (response['status']) {
                String uname = response['username'];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message See you again, $uname."),
                ));
                // Kembali ke halaman Login dan hapus history navigasi
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                ));
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}