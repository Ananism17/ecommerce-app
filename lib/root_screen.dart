import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
// import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/contact_screen.dart';
import 'package:ecommerce_app/screens/home/home_screen.dart';
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
      // bottomNavigationBar: NavigationBar(
      //   selectedIndex: currentScreen,
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   height: kBottomNavigationBarHeight,
      //   destinations: const [
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.home),
      //       icon: Icon(Icons.home_outlined),
      //       label: "Home",
      //     ),
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.search),
      //       icon: Icon(Icons.search_outlined),
      //       label: "Search",
      //     ),
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.shopping_cart),
      //       icon: Badge(
      //         label: Text("6"),
      //         backgroundColor: AppColors.buroLogoGreen,
      //         child: Icon(Icons.shopping_cart_outlined),
      //       ),
      //       label: "Cart",
      //     ),
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.person),
      //       icon: Icon(Icons.person_outlined),
      //       label: "Profile",
      //     ),
      //   ],
      //   onDestinationSelected: (index) {
      //     setState(() {
      //       currentScreen = index;
      //     });
      //     controller.jumpToPage(currentScreen);
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Set currentScreen to the index of the TestScreen
          setState(() {
            currentScreen = 4; // Assuming TestScreen is at index 3
            controller.jumpToPage(currentScreen);
          });
        },
        backgroundColor: themeProvider.getIsDarkTheme
            ? AppColors.darkBarColor
            : Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: themeProvider.getIsDarkTheme
            ? currentScreen == 4
                ? AppColors.buroLogoGreen
                : AppColors.buroLogoOrange
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
            ? AppColors.buroLogoOrange
            : AppColors.buroLogoGreen,
        activeColor: themeProvider.getIsDarkTheme
            ? AppColors.buroLogoGreen
            : AppColors.buroLogoOrange,
      ),
    );
  }
}
