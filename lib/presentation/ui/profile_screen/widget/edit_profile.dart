import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';

import 'package:doni_pizza/presentation/widgets/global_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                LocaleKeys.editProfile.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GlobalTextField(
                hintText: 'Doni Pizza',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                caption: LocaleKeys.name.tr(),
              ),
              const SizedBox(height: 20),
              GlobalTextField(
                hintText: '+(998) 99-999-99',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                caption: LocaleKeys.phone_number.tr(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    )),
                onPressed: () {
                  String name = nameController.text;
                  String phone = phoneController.text;
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
