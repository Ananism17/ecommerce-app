//flutter
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/orders/order_list.dart';
import 'package:ecommerce_app/screens/payments/payment_list.dart';
import 'package:ecommerce_app/widgets/app_name_text.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';

//assets
import 'package:ecommerce_app/services/assets_manager.dart';

//widgets
import 'package:ecommerce_app/widgets/title_text.dart';

//theme providers
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // Show an alert dialog when the back button is pressed
        bool exit = await _showExitConfirmationDialog(context) ?? false;
        return exit;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: themeProvider.getIsDarkTheme
                ? Image.asset(AssetManager.logoWhiteImagePath)
                : Image.asset(AssetManager.logoImagePath),
          ),
          title: const AppNameText(),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: themeProvider.getIsDarkTheme
                              ? AppColors.buroLogoOrange
                              : AppColors.buroLogoGreen,
                          width: 3,
                        ),
                        image: DecorationImage(
                          image: themeProvider.getIsDarkTheme
                              ? AssetImage(AssetManager.userWhiteImagePath)
                              : AssetImage(AssetManager.userBlackImagePath),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(label: userProvider.userName),
                          const SizedBox(
                            height: 6,
                          ),
                          SubtitleText(
                            label: userProvider.userEmail,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleText(
                      label: "General",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomListTile(
                      imagePath: themeProvider.getIsDarkTheme
                          ? AssetManager.orderLogoImagePath
                          : AssetManager.orderLogoLightImagePath,
                      text: "All Orders",
                      function: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const OrderList(),
                          ),
                        );
                      },
                    ),
                    CustomListTile(
                      imagePath: themeProvider.getIsDarkTheme
                          ? AssetManager.paymentCELogoImagePath
                          : AssetManager.paymentCELogoLightImagePath,
                      text: "Payments for CE",
                      function: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const PaymentList(
                              type: "CE",
                            ),
                          ),
                        );
                      },
                    ),
                    CustomListTile(
                      imagePath: themeProvider.getIsDarkTheme
                          ? AssetManager.paymentDeviceLogoImagePath
                          : AssetManager.paymentDeviceLogoLightImagePath,
                      text: "Payments for Device",
                      function: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const PaymentList(
                              type: "Device",
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleText(
                      label: "Settings",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SwitchListTile(
                      secondary: Image.asset(
                        themeProvider.getIsDarkTheme
                            ? AssetManager.settingsLogoImagePath
                            : AssetManager.settingsLogoLightImagePath,
                        height: 40,
                      ),
                      title: Text(themeProvider.getIsDarkTheme
                          ? "Dark Mode"
                          : "Light Mode"),
                      value: themeProvider.getIsDarkTheme,
                      onChanged: (value) {
                        themeProvider.setDarkTheme(value);
                      },
                    ),
                    // CustomListTile(
                    //   imagePath: themeProvider.getIsDarkTheme
                    //       ? AssetManager.passwordLogoImagePath
                    //       : AssetManager.passwordLogoLightImagePath,
                    //   text: "Change Password",
                    //   function: () {},
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    TokenProvider tokenProvider = context.read<TokenProvider>();
                    tokenProvider.setToken("");

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => const LoginScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('No'),
            onPressed: () {
              // Navigator.pop returns false to WillPopScope
              Navigator.pop(context, false);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes'),
            onPressed: () {
              // Navigator.pop returns true to WillPopScope
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });

  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        function();
      },
      title: Text(text),
      leading: Image.asset(
        imagePath,
        height: 35,
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }
}
