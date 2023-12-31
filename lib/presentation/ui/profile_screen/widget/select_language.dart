import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/utils/local_storage/storage_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doni_pizza/presentation/ui/profile_screen/widget/language_detail.dart';
import 'package:doni_pizza/presentation/ui/tab_box/tab_box.dart';
import 'package:doni_pizza/utils/icons.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  String selectedLanguage = 'en';
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() async {
    final savedLanguage = StorageRepository.getString('selectedLanguage');

    setState(() {
      selectedLanguage = savedLanguage;
    });
  }

  void handleLanguageChange(String language) {
    setState(() {
      selectedLanguage = language;
    });

    StorageRepository.putString('selectedLanguage', language);
    context.setLocale(Locale(language));
  }

  void startProcessing() {
    setState(() {
      isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isProcessing = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => const TabBox(),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isProcessing
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: Text(
                LocaleKeys.language.tr(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: startProcessing,
                  icon: const Icon(Icons.compare_arrows, color: Colors.black),
                ),
              ],
            ),
      body: isProcessing
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.grey.shade300),
                child: const Padding(
                  padding: EdgeInsets.all(35.0),
                  child: CupertinoActivityIndicator(color: Colors.black),
                ),
              ),
            )
          : Column(
              children: [
                LanguageDetail(
                  textColor: Colors.black,
                  icon: SvgPicture.asset(AppImages.usa, height: 30),
                  text: 'English'.tr(),
                  showSwitch: true,
                  isSelected: selectedLanguage == 'en',
                  onSelected: (value) {
                    handleLanguageChange('en');
                  },
                ),
                LanguageDetail(
                  textColor: Colors.black,
                  icon: SvgPicture.asset(AppImages.rus, height: 30),
                  text: 'Русский'.tr(),
                  showSwitch: true,
                  isSelected: selectedLanguage == 'ru',
                  onSelected: (value) {
                    handleLanguageChange('ru');
                  },
                ),
                LanguageDetail(
                  textColor: Colors.black,
                  icon: SvgPicture.asset(AppImages.uzb, height: 30),
                  text: 'Uzbek'.tr(),
                  showSwitch: true,
                  isSelected: selectedLanguage == 'uz',
                  onSelected: (value) {
                    handleLanguageChange('uz');
                  },
                ),
              ],
            ),
    );
  }
}
