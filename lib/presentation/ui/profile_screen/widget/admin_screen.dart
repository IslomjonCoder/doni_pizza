import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:doni_pizza/utils/icons.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Future<void> _sendEmail(String email) async {
    if (await canLaunchUrl(Uri(scheme: 'mailto', path: email))) {
      await launchUrl(Uri(scheme: 'mailto', path: email));
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl( phoneLaunchUri);
    }
  }

  Widget _buildContactInfo(String name, String email, String phoneNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Developer $name:\n",
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Sora',
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        Row(
          children: [
            const Text(
              "Email: ",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Sora',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            InkWell(
              onTap: () => _sendEmail(email),
              child: Row(
                children: [
                  Text(
                    "$email   ",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Sora',
                      fontSize: 13,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const Icon(Icons.email, color: Colors.orange),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              "Telefon: ",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Sora',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            ZoomTapAnimation(
              onTap: () => _makeCall(phoneNumber),
              child: Row(
                children: [
                  Text(
                    "$phoneNumber   ",
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontFamily: 'Sora',
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const Icon(Icons.phone, color: Colors.green),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Icon(Icons.settings, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                """Tizimda muammolar paydo bo'lsa, Ilova developer lari bilan bog'laning!\n\nUlar bilan bog'lanish uchun quyidagi ma'lumotlarni ishlatishingiz mumkin:
""",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Sora',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildContactInfo("Islomjon", "islomjon20010930@gmail.com", "+(998) 94 902-01-30"),
              const SizedBox(height: 50.0),
              _buildContactInfo(
                  "Nurmuxammad", "nurmuhammadzoyidov@gmail.com", "+(998) 91 271-95-55"),
              const SizedBox(height: 20.0),
              Center(child: SvgPicture.asset(AppImages.dev)),
              const Center(child: Text("Taklif va Shikoyatlar uchun")),
            ],
          ),
        ),
      ),
    );
  }
}
