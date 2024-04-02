import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/root_screen.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var obscureText = true;

  late ImageProvider backgroundImage;

  @override
  void initState() {
    super.initState();
    backgroundImage = AssetImage(AssetManager.loginBackgroundImagePath);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(backgroundImage, context);
  }

  void _switchVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const RootScreen(),
      ),
    );
  }

  Future<void> _login() async {
    final url = Uri.parse('${AppConstants.baseUrl}api/v1/auth/login');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final data = <String, String>{
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );

    final jsonResponse = json.decode(response.body);
    final status = jsonResponse['status'];

    if (status) {
      // ignore: use_build_context_synchronously
      TokenProvider tokenProvider = context.read<TokenProvider>();
      tokenProvider.setToken(jsonResponse['access_token']);

      // ignore: use_build_context_synchronously
      UserProvider userProvider = context.read<UserProvider>();
      userProvider.updateUser(
          jsonResponse['user']['name'],
          jsonResponse['user']['email'],
          jsonResponse['user']['phone'],
          jsonResponse['user']['address'],
          jsonResponse['user']['company_id']);

      _goHome();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text(
            "Invalid Credentials!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage,
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image.asset(AssetManager.samsungImagePath),
                  Image.asset(AssetManager.fairImagePath),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      label: Text(
                        "Mobile / Email",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: obscureText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      label: const Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: _switchVisibility,
                        icon: Icon(obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buroLogoOrange,
                          ),
                          onPressed: _login,
                          // onPressed: _goHome,
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
