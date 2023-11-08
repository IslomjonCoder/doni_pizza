import 'package:doni_pizza/presentation/ui/home_screen/promotions/sot_of_doni_pizza.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../utils/icons.dart';
import 'doni_pizza_banner.dart';

class Promotions extends StatelessWidget {
  Promotions({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 1.60,
          enlargeCenterPage: true,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 2),
        ),
        items: const [
          Doni_pizza_banner(),
          SetOfDoniPizza(image: AppImages.dostavka,),
          SetOfDoniPizza(image: AppImages.juftlik,),
          SetOfDoniPizza(image: AppImages.dostlar,),
          SetOfDoniPizza(image: AppImages.burger,),

        ]);
  }
}


