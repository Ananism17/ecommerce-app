import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/root_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

   Future<void> _checkTokenAndNavigate() async {
    TokenProvider tokenProvider = context.read<TokenProvider>();
    String token = await tokenProvider.getToken();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => token.isNotEmpty ? const RootScreen() : const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Buro BD'),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetManager.welcomeImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                period: const Duration(seconds: 2),
                baseColor: AppColors.buroLogoOrange,
                highlightColor: const Color.fromARGB(255, 214, 72, 29),
                child: const TitleText(
                  label: "WELCOME",
                  fontSize: 38,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Unlock Your Business Potential with',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.getIsDarkTheme
                      ? const Color.fromARGB(255, 30, 187, 122)
                      : AppColors.buroLogoGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Fair Electronics SME',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.getIsDarkTheme
                      ? const Color.fromARGB(255, 30, 187, 122)
                      : AppColors.buroLogoGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const SpinKitFoldingCube(
                color: Colors.orange,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
