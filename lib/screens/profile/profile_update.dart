import 'dart:convert';

import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/constants/app_constants.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/root_screen.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late TextEditingController nameTextController;
  late TextEditingController addressTextController;
  late TextEditingController phoneTextController;

  bool dataFetched = false;

  @override
  void initState() {
    nameTextController = TextEditingController();
    addressTextController = TextEditingController();
    phoneTextController = TextEditingController();
    fetchProfile();
    super.initState();
  }

  Future fetchProfile() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;

    final url = Uri.parse('${AppConstants.baseUrl}api/v1/auth/my-profile');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonResponse = json.decode(response.body);

    final status = jsonResponse['status'];

    if (status) {
      final data = jsonResponse['user'];

      setState(() {
        dataFetched = true;
        nameTextController.text = data['name'] as String;
        addressTextController.text = data['address'] as String;
        phoneTextController.text = data['phone'] as String;
      });
    }
    // print(productList);
    else {
      // print(jsonResponse);
    }
    return;
  }

  Future<void> _update() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    String token = tokenProvider.getAccessToken;
    final url = Uri.parse('${AppConstants.baseUrl}api/v1/auth/profile/update');
    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final data = <String, String>{
      'name': nameTextController.text,
      'mobile': phoneTextController.text,
      'address': addressTextController.text,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );

    final jsonResponse = json.decode(response.body);
    final status = jsonResponse['status'];

    print(jsonResponse);

    if (status) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          content: Text(
            "Profile updated succesfully!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
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
            "Could Not Update the Profile!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const RootScreen(),
      ),
    );
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return dataFetched
        ? Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_sharp,
                ),
              ),
              title: const TitleText(label: "Profile"),
              elevation: 5,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleText(label: "Update Profile"),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: nameTextController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    onChanged: (value) {},
                    onSubmitted: (value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: phoneTextController,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                    ),
                    onChanged: (value) {},
                    onSubmitted: (value) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: addressTextController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                    ),
                    onChanged: (value) {},
                    onSubmitted: (value) {},
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buroLogoGreen,
                        ),
                        onPressed: _update,
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_sharp,
                ),
              ),
              title: const TitleText(label: "Profile"),
              elevation: 5,
            ),
            body: Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: themeProvider.getIsDarkTheme
                    ? Colors.white
                    : Colors.lightBlue,
                size: 60,
                secondRingColor: AppColors.buroLogoGreen,
                thirdRingColor: AppColors.buroLogoOrange,
              ),
            ),
          );
  }
}
