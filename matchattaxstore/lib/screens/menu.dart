import 'package:flutter/material.dart';
// Impor file drawer dan form yang baru dibuat
import 'package:matchattaxstore/widgets/left_drawer.dart';
import 'package:matchattaxstore/screens/product_form.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String nama = "Aryandana Pascua Patiung";
  final String npm = "2406438214";
  final String kelas = "F";

  final List<ItemHomepage> items = [
    ItemHomepage("All Products", Icons.storefront, Colors.grey[800]!), // Abu-abu gelap
    ItemHomepage("My Products", Icons.shopping_bag, Colors.grey[700]!), // Abu-abu sedang
    ItemHomepage("Create Product", Icons.add_box, Colors.black54), // Abu-abu/hitam
  ];

// ... sisa kode menu.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Match Attax Store',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white, // Tambahkan ini agar icon menu (hamburger) putih
      ),
      
      // TAMBAHKAN DRAWER DI SINI
      drawer: const LeftDrawer(),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row untuk info NPM, Nama, Kelas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: nama),
                InfoCard(title: 'Class', content: kelas),
              ],
            ),

            const SizedBox(height: 16.0),

            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Selamat datang di Match Attax Store',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),

                  // Grid tombol (3 item)
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Tampilkan SnackBar
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content:
                    Text("Kamu telah menekan tombol ${item.name}!"),
                duration: const Duration(seconds: 2),
              ),
            );

          // TAMBAHKAN NAVIGASI DI SINI
          if (item.name == "Create Product") {
            // Gunakan Navigator.push
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductFormPage(),
              ),
            );
          }
          // Anda bisa tambahkan else if untuk tombol lain nanti
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
                  size: 32.0,
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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