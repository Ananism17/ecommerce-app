import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
// import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/contacts/contact_screen.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/profile_screen.dart';
import 'package:ecommerce_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;

  List<IconData> iconList = [
    Icons.home,
    Icons.search,
    Icons.contact_phone,
    Icons.person
  ];

  @override
  void initState() {
    super.initState();
    screens = const [
      HomeScreen(),
      SearchScreen(),
      ContactScreen(),
      ProfileScreen(),
      CartScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentScreen = 4;
            controller.jumpToPage(currentScreen);
          });
        },
        backgroundColor: themeProvider.getIsDarkTheme
            ? AppColors.darkBarColor
            : Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: themeProvider.getIsDarkTheme
            ? currentScreen == 4
                ? Colors.white
                : Colors.yellow
            : currentScreen == 4
                ? AppColors.buroLogoOrange
                : AppColors.buroLogoGreen,
        child: const Icon(
          Icons.shopping_cart,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        elevation: 10,
        icons: iconList,
        activeIndex: currentScreen,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: (index) {
          setState(
            () {
              currentScreen = index;
              controller.jumpToPage(currentScreen);
            },
          );
        },
        backgroundColor: themeProvider.getIsDarkTheme
            ? AppColors.darkBarColor
            : Theme.of(context).scaffoldBackgroundColor,
        inactiveColor: themeProvider.getIsDarkTheme
            ? Colors.yellow
            : AppColors.buroLogoGreen,
        activeColor: themeProvider.getIsDarkTheme
            ? Colors.white
            : AppColors.buroLogoOrange,
      ),
    );
  }

  
}
