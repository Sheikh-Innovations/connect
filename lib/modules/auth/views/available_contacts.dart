import 'package:connect/modules/auth/controllers/auth_controller.dart';
import 'package:connect/screens/chat_inside.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Adjust the import based on your project structure

class ContactComparisonScreen extends GetView<AuthController> {
  const ContactComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.availableContacts();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Available Contacts'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }

        // Check if contacts are null or empty
        final contacts = controller.contacts.value;
        if (contacts == null || contacts.matchingContacts.isEmpty) {
          return const Center(
            child: Text('No user in your contact'),
          );
        }

        return ListView.builder(
          itemCount: contacts.matchingContacts.length,
          itemBuilder: (context, index) {
            final contact = contacts.matchingContacts[index];
            return ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/abstract-autumn-beauty-multi-colored-leaf-vein-pattern-generated-by-ai_188544-9871.jpg'),
              ),
              title: Text(contact.name ?? 'No Name'),
              subtitle: Text(contact.number),
              trailing: const Icon(Icons.message),
              onTap: () {
                Get.to(ChatInsideScreen(
                  name: contact.name ?? 'Unknown',
                  senderId: contact.id,
                ));
              },
            );
          },
        );
      }),
    );
  }
}
