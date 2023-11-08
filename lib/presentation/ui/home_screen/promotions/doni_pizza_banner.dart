import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../utils/icons.dart';


class Doni_pizza_banner extends StatelessWidget {
  const Doni_pizza_banner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          alignment: Alignment.centerRight,
          fit: BoxFit.fitHeight,
          image: AssetImage(AppImages.promotionImage),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Colors.grey,
            Colors.grey,
            Colors.black,
            Colors.black,
            Colors.black,
          ],
        ),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Doni Pizza",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              fontFamily: 'Sora',
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ZoomTapAnimation(
                    onTap: () {
                      launch("tel:+998941590509");
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.green,
                        ),
                        Text(
                          '  +(998) 94 159-05-09',
                          style: TextStyle(color: Colors.white, fontFamily: 'Sora'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0,),
              Row(
                children: [
                  ZoomTapAnimation(
                    onTap: () {
                      final String locationUrl = "https://yandex.com/navi/?ll=70.546895%2C41.045763&mode=routes&rtext=41.293235%2C69.276259~41.076267%2C71.818334&rtt=auto&ruri=~&z=8";
                      launch(locationUrl);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Colors.red,
                        ),
                        Text(
                          '  Namangan/Chortoq',
                          style: TextStyle(color: Colors.white, fontFamily: 'Sora'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0,),
              Row(
                children: [
                  Icon(
                    Icons.watch_later,
                    color: Colors.amber,
                  ),
                  Text('  Ish vaqti: 9:00/02:00',
                      style: TextStyle(color: Colors.white, fontFamily: 'Sora')),
                ],
              ),
              SizedBox(height: 5.0,),
              Row(
                children: [
                  Icon(
                    Icons.directions_run,
                    color: Colors.cyanAccent,
                  ),
                  Text('  Dostavka xizmati siz uchun',
                      style: TextStyle(color: Colors.white, fontFamily: 'Sora')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}