import 'package:ecommerce_app/screens/contacts/contact_card.dart';
import 'package:ecommerce_app/widgets/title_text.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.contact_phone,
              ),
            ),
          ),
          title: const TitleText(label: "Contact US"),
          elevation: 5,
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
