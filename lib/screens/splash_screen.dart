import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Buro BD'),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome.png'),
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
              const Text(
                'Unlock Your Business Potential with',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buroLogoGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'FairElectronics SME',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buroLogoGreen,
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
