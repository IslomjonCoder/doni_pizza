import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/utils/helpers/firebase_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/ui/profile_screen/widget/about_us.dart';
import 'package:doni_pizza/presentation/ui/profile_screen/widget/admin_screen.dart';
import 'package:doni_pizza/presentation/ui/profile_screen/widget/edit_profile.dart';
import 'package:doni_pizza/presentation/ui/profile_screen/widget/select_language.dart';
import 'package:doni_pizza/presentation/widgets/dialog_gallery_camera.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'widget/profile_detail.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedImagePath;
  final String profileImageKey = "profile_image";
  String? username;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          LocaleKeys.profile.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0, bottom: 5.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const AboutUsScreen()));
              },
              icon: const Icon(Icons.account_balance_outlined, color: Colors.black),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ZoomTapAnimation(
              onTap: () async {
                showCameraAndGalleryDialog(context, (imagePath) async {
                  if (imagePath != null) {
                    setState(() {
                      selectedImagePath = imagePath;
                    });
                    final url = await TFirebaseHelper.uploadImage(
                        File(imagePath), 'images/profile/${imagePath.split('/').last}');
                    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'imageUrl': url});
                    context.read<AuthCubit>().updateImageUrl(url);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: selectedImagePath == null ? Colors.grey.shade400 : Colors.black,
                ),
                child: selectedImagePath != null || context.watch<AuthCubit>().state.userModel?.imageUrl != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(120),
                            child: context.watch<AuthCubit>().state.userModel != null &&
                                    context.watch<AuthCubit>().state.userModel!.imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: context.watch<AuthCubit>().state.userModel!.imageUrl!,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(selectedImagePath!),
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Icon(
                          CupertinoIcons.camera,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            Column(
              children: [
                Text(
                  context.watch<AuthCubit>().state.userModel != null
                      ? context.read<AuthCubit>().state.userModel!.name
                      : LocaleKeys.user.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: 20,
                  ),
                ),
                Text(
                  context.watch<AuthCubit>().state.userModel != null
                      ? context.read<AuthCubit>().state.userModel!.phoneNumber
                      : '+(998) __ ___ __ __',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Sora',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  ProfileDetail(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                    },
                    textColor: Colors.black,
                    icon: const Icon(Icons.person),
                    text: LocaleKeys.myProfile.tr(),
                    showArrow: true,
                    showSwitch: false,
                  ),
                  ProfileDetail(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const SelectLanguage()));
                    },
                    textColor: Colors.black,
                    icon: const Icon(Icons.language),
                    text: LocaleKeys.language.tr(),
                    showArrow: true,
                    showSwitch: false,
                  ),
                  // ProfileDetail(
                  //   textColor: Colors.black,
                  //   icon: const Icon(Icons.access_time_outlined),
                  //   text: 'Save Orders',
                  //   showArrow: false,
                  //   showSwitch: true,
                  // ),
                  ProfileDetail(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const AdminScreen()));
                    },
                    textColor: Colors.black,
                    icon: const Icon(Icons.admin_panel_settings_rounded),
                    text: LocaleKeys.appAdmin.tr(),
                    showArrow: true,
                    showSwitch: false,
                  ),
                  ProfileDetail(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: ShapeBorder.lerp(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              0.5,
                            ),
                            title: Text(
                              LocaleKeys.logout.tr(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Sora',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: Text(LocaleKeys.logout_popup.tr()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  LocaleKeys.no.tr(),
                                  style: const TextStyle(color: Colors.black, fontFamily: 'Sora'),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<AuthCubit>().logout();
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                                },
                                child: Text(
                                  LocaleKeys.yes.tr(),
                                  style: const TextStyle(color: Colors.red, fontFamily: 'Sora'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    textColor: Colors.black,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    text: LocaleKeys.logout.tr(),
                    showArrow: false,
                    showSwitch: false,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
