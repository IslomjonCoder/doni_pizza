import 'package:doni_pizza/business_logic/auth_bloc.dart';
import 'package:doni_pizza/business_logic/auth_event.dart';
import 'package:doni_pizza/business_logic/auth_state.dart';
import 'package:doni_pizza/presentation/ui/orders/order_detail.dart';
import 'package:doni_pizza/presentation/ui/tab_box/tab_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';

import 'package:doni_pizza/presentation/widgets/global_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.userDataUpdateStatus == Status.success) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const TabBox(),
                ),
                (route) => false);
          } else if (state.userDataUpdateStatus == Status.failure) {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text(LocaleKeys.error.tr()),
                    content: Text(state.error!),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(LocaleKeys.ok.tr()),
                      ),
                    ]);
              },
            );
          } else if (state.userDataUpdateStatus == Status.loading) {
            loadingDialog(context);
          }
        },
        child: Padding(
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
                  controller: nameController,
                  hintText: 'Doni Pizza',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  caption: LocaleKeys.name.tr(),
                ),
                const SizedBox(height: 20),
                GlobalTextField(
                  controller: phoneController,
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
                    context.read<AuthBloc>().add(UpdateUserDataEvent(
                          name: name,
                          phoneNumber: phone,
                        ));
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
