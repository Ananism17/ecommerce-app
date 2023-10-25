//flutter
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/providers/token_provider.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/orders/order_list.dart';
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

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(AssetManager.logoImagePath),
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
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleText(label: "Anan Diljar"),
                        SizedBox(
                          height: 6,
                        ),
                        SubtitleText(label: "anandiljar5@gmail.com")
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
                    imagePath: AssetManager.orderLogoImagePath,
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
                    imagePath: AssetManager.paymentCELogoImagePath,
                    text: "Payments for CE",
                    function: () {},
                  ),
                  CustomListTile(
                    imagePath: AssetManager.paymentDeviceLogoImagePath,
                    text: "Payments for Device",
                    function: () {},
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
                      AssetManager.themeLogoImagePath,
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
        height: 40,
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }
}
