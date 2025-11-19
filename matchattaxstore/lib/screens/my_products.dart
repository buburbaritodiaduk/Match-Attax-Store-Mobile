import 'package:flutter/material.dart';
import 'package:matchattaxstore/models/product_entry.dart';
import 'package:matchattaxstore/widgets/left_drawer.dart';
import 'package:matchattaxstore/screens/product_detail.dart';
import 'package:matchattaxstore/widgets/product_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  Future<List<ProductEntry>> fetchMyProducts(CookieRequest request) async {
    try {
      // Coba gunakan endpoint khusus untuk produk user yang login
      // Jika endpoint ini tidak ada di Django, akan fallback ke endpoint umum
      try {
        final response = await request.get('http://127.0.0.1:8000/json/my-products/');
        var data = response;
        List<ProductEntry> listProducts = [];
        for (var d in data) {
          if (d != null) {
            listProducts.add(ProductEntry.fromJson(d));
          }
        }
        return listProducts;
      } catch (e) {
        // Jika endpoint khusus tidak ada, ambil semua produk dan filter di Flutter
        final response = await request.get('http://127.0.0.1:8000/json/');
        var data = response;
        
        // Convert json data to ProductEntry objects
        List<ProductEntry> listProducts = [];
        for (var d in data) {
          if (d != null) {
            listProducts.add(ProductEntry.fromJson(d));
          }
        }

        // Coba dapatkan user_id dari beberapa endpoint yang mungkin ada
        int? currentUserId;
        
        // Coba endpoint /auth/user/ terlebih dahulu
        try {
          final userResponse = await request.get('http://127.0.0.1:8000/auth/user/');
          if (userResponse != null) {
            // Cek berbagai kemungkinan format response
            if (userResponse['user_id'] != null) {
              currentUserId = userResponse['user_id'] as int;
            } else if (userResponse['id'] != null) {
              currentUserId = userResponse['id'] as int;
            } else if (userResponse['pk'] != null) {
              currentUserId = userResponse['pk'] as int;
            }
          }
        } catch (e) {
          // Jika endpoint /auth/user/ tidak ada, coba endpoint lain
          try {
            final userResponse = await request.get('http://127.0.0.1:8000/auth/whoami/');
            if (userResponse != null) {
              if (userResponse['user_id'] != null) {
                currentUserId = userResponse['user_id'] as int;
              } else if (userResponse['id'] != null) {
                currentUserId = userResponse['id'] as int;
              } else if (userResponse['pk'] != null) {
                currentUserId = userResponse['pk'] as int;
              }
            }
          } catch (e2) {
            // Jika semua endpoint tidak ada, kita tidak bisa filter
            // Return empty list karena tidak bisa memastikan user_id
            return [];
          }
        }

        // Filter produk berdasarkan user_id yang sedang login
        if (currentUserId != null) {
          listProducts = listProducts.where((product) {
            return product.userId == currentUserId;
          }).toList();
        } else {
          // Jika tidak bisa dapat user_id, return empty list
          return [];
        }

        return listProducts;
      }
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
        title: const Text('My Products'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<ProductEntry>>(
        future: fetchMyProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
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
                  Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'You haven\'t created any products yet.',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first product to see it here!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
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

