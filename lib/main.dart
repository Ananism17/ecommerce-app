import 'package:ecommerce_app/constants/theme_data.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/splash_screen.dart';
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
        }),
        ChangeNotifierProvider(create: (_) {
          return CartProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return UserProvider();
        }),
      ],
      child:
          Consumer4<ThemeProvider, TokenProvider, CartProvider, UserProvider>(
              builder: (context, theneProvider, tokenProvider, cartProvider,
                  userProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ecommerce App',
          theme: Styles.themeData(
              isDarkTheme: theneProvider.getIsDarkTheme, context: context),
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
        );
      }),
    );
  }
}
