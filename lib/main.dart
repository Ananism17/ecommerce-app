import 'package:ecommerce_app/constants/theme_data.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ThemeProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return TokenProvider();
        })
      ], 
      child: Consumer2<ThemeProvider, TokenProvider>(
        builder: (context, theneProvider, tokenProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ecommerce App',
            theme: Styles.themeData(isDarkTheme: theneProvider.getIsDarkTheme, context: context),
            themeMode: ThemeMode.system,
            home: const LoginScreen(),
          );
        }
      ),
    );
  }
}
