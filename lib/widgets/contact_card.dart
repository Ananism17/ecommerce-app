import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/providers/theme_provider.dart';
import 'package:ecommerce_app/services/assets_manager.dart';
import 'package:ecommerce_app/widgets/subtitle_text.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.title,
    required this.name,
    required this.phone,
    required this.email,
    this.designation = "",
    this.company = "",
  });

  final String title, name, designation, company, phone, email;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      elevation: 5,
      color: themeProvider.getIsDarkTheme
          ? const Color.fromARGB(255, 3, 51, 90)
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleText(
                label: title,
                fontSize: 20,
                maxLines: 2,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: themeProvider.getIsDarkTheme
                            ? Colors.white
                            : const Color.fromARGB(255, 104, 102, 102),
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
                    width: 30,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleText(
                          label: name,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SubtitleText(label: designation),
                        const SizedBox(
                          height: 10,
                        ),
                        SubtitleText(label: company),
                        const SizedBox(
                          height: 10,
                        ),
                        SubtitleText(label: phone),
                        const SizedBox(
                          height: 10,
                        ),
                        SubtitleText(label: email),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
