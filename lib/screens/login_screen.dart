import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/root_screen.dart';
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    label: Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: obscureText,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    label: const Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _switchVisibility,
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buroLogoGreen,
                        ),
                        onPressed: _login,
                        // onPressed: _goHome,
                        child: const Text("Login"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
