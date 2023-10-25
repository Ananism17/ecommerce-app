import 'package:ecommerce_app/screens/contacts/contact_card.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.contact_phone,
            ),
          ),
        ),
        title: const TitleText(label: "Contact US"),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ContactCard(
                title: "Contact for Consumer Electronics",
                name: 'Md. Foyshal Hossian',
                phone: '+8801700718644',
                email: "foyshal.hossain@fel.com.bd",
                designation: "Assistant Manager",
                company: "Fair Electronics Ltd.",
              ),
              SizedBox(
                height: 20,
              ),
              ContactCard(
                title: "Contact for Mobile Phone",
                name: 'Md. Gulam Mahbub Bhuiyan',
                phone: '+8801777702109',
                email: "mahbub.bhuiyan@fel.com.bd",
                designation: "Assistant Manager",
                company: "Fair Electronics Ltd.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
