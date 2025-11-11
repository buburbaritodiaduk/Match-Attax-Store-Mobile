import 'package:flutter/material.dart';
import 'package:matchattaxstore/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Attax Store',
      theme: ThemeData(
        // Mengganti tema menjadi monokrom (abu-abu)
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(
          secondary: Colors.black54, // Warna sekunder (misal: aksen tombol)
          brightness: Brightness.light, // Latar belakang terang
        ),
        
        // Kita juga bisa atur warna AppBar secara eksplisit di sini
        // agar konsisten di seluruh aplikasi
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850], // Abu-abu gelap untuk AppBar
          foregroundColor: Colors.white, // Teks/ikon putih di AppBar
        ),

        // Memastikan warna tombol Elevated juga konsisten
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[850]), // Abu-abu gelap
            foregroundColor: MaterialStateProperty.all(Colors.white), // Teks putih
          ),
        ),

      ),
      home: MyHomePage(),
    );
  }
}