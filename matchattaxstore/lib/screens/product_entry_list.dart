import 'package:flutter/material.dart';
import 'package:matchattaxstore/models/product_entry.dart';
import 'package:matchattaxstore/widgets/left_drawer.dart';
import 'package:matchattaxstore/screens/product_detail.dart';
import 'package:matchattaxstore/widgets/product_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductEntryListPage extends StatefulWidget {
  const ProductEntryListPage({super.key});

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2:8000/json/
    // If you using chrome,  use URL http://127.0.0.1:8000/json/

    try {
      final response = await request.get('http://127.0.0.1:8000/json/');

      // Decode response to json format
      var data = response;

      // Convert json data to ProductEntry objects
      List<ProductEntry> listProducts = [];
      for (var d in data) {
        if (d != null) {
          listProducts.add(ProductEntry.fromJson(d));
        }
      }
      return listProducts;
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pastikan Django server sudah berjalan di http://127.0.0.1:8000',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'There are no products in the store yet.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => ProductEntryCard(
                product: snapshot.data![index],
                onTap: () {
                  // Navigate to product detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: snapshot.data![index]),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}