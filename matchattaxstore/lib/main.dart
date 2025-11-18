import 'package:flutter/material.dart';
import 'package:matchattaxstore/screens/login.dart';
import 'package:matchattaxstore/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Match Attax Store',
        theme: ThemeData(
          // Mengganti tema menjadi monokrom (abu-abu)
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
            secondary: Colors.black54,
            brightness: Brightness.light,
          ),

          // Pengaturan AppBar
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[850],
            foregroundColor: Colors.white,
          ),

          // Pengaturan Tombol
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}