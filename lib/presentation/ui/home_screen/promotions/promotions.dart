import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doni_pizza/business_logic/blocs/promotion_bloc/promotion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'doni_pizza_banner.dart';

class Promotions extends StatelessWidget {
  const Promotions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionBloc, PromotionState>(
      builder: (context, state) {
        print(state);
        if (state is PromotionError) print(state.error);

        if (state is PromotionInitial) {
          context.read<PromotionBloc>().add(GetAllPromotions());
        } else if (state is PromotionLoaded) {
          return CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 1.60,
                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                enlargeCenterPage: true,
                viewportFraction: 1,
                // autoPlayInterval: const Duration(seconds: 10),
                // autoPlayCurve: Curves.easeInCubic

              ),
              items: [
                const Doni_pizza_banner(),
                ...List.generate(
                    state.promotions.length,
                    (index) => Container(
                          child: CachedNetworkImage(
                            imageUrl: state.promotions[index].imageUrl,
                            fit: BoxFit.fitWidth,
                          ),
                        ))
                // SetOfDoniPizza(image: AppImages.dostavka,),
                // SetOfDoniPizza(image: AppImages.juftlik,),
                // SetOfDoniPizza(image: AppImages.dostlar,),
                // SetOfDoniPizza(image: AppImages.burger,),
              ]);
        }
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

              // SetOfDoniPizza(image: AppImages.dostavka,),
              // SetOfDoniPizza(image: AppImages.juftlik,),
              // SetOfDoniPizza(image: AppImages.dostlar,),
              // SetOfDoniPizza(image: AppImages.burger,),
            ]).applyShimmer();
      },
    );
  }
}
