import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doni_pizza/business_logic/blocs/cart_bloc/state_bloc.dart';
import 'package:doni_pizza/utils/device/device_utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/ui/orders/order_detail.dart';
import 'package:doni_pizza/utils/icons.dart';
import 'package:gap/gap.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AppStyles {
  static const TextStyle appBarTitle = TextStyle(
    color: Colors.black,
    fontFamily: 'Sora',
    fontWeight: FontWeight.w600,
    fontSize: 30,
  );

  static const TextStyle clearButton = TextStyle(
    color: Colors.red,
    fontFamily: 'Sora',
    fontWeight: FontWeight.w600,
    fontSize: 15,
  );

  static const TextStyle itemTitle = TextStyle(
    color: Colors.black,
    fontFamily: 'Sora',
  );

  static const TextStyle itemPrice = TextStyle(
    color: Colors.black,
    fontFamily: 'Sora',
  );

  static const TextStyle itemCount = TextStyle(
    color: Colors.black87,
  );

  static const TextStyle orderButton = TextStyle(
    color: Colors.white,
    fontFamily: 'Sora',
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static const TextStyle emptyCartText = TextStyle(
    fontFamily: 'Sora',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

class AppSizes {
  static const double horizontalPadding = 16.0;
  static const double verticalPadding = 5.0;
  static const double appBarTitleSize = 30;
  static const double clearButtonSize = 15;
  static const double emptyCartTextSize = 20;
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final foodBloc = context.read<FoodBloc>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(LocaleKeys.cart.tr(),
            style: AppStyles.appBarTitle.copyWith(fontSize: AppSizes.appBarTitleSize)),
        actions: [
          ZoomTapAnimation(
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.bottomSlide,
                title: LocaleKeys.clearCart.tr(),
                btnOkOnPress: () => foodBloc.add(ClearCartEvent()),
                btnOkIcon: Icons.delete,
                btnOkColor: Colors.red,
                btnOkText: LocaleKeys.yes.tr(),
              ).show();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  LocaleKeys.clear.tr(),
                  style: AppStyles.clearButton.copyWith(fontSize: AppSizes.clearButtonSize),
                ),
              ),
            ),
          ),
        ],
      ),
      // ...
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is TodoInitialState || state is FoodLoadingState) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          } else if (state is FoodErrorState) {
            return Center(child: Text(state.errorMessage, textAlign: TextAlign.center));
          } else if (state is FoodLoadedState) {
            return state.foods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppImages.emptyCart),
                        const SizedBox(height: AppSizes.verticalPadding * 6), // Adjusted size
                        Text(LocaleKeys.emptyCart.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Sora",
                            )), // Adjusted size
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.foods.length,
                          itemBuilder: (context, index) {
                            final item = state.foods[index];
                            return ListTile(
                              title: Text(
                                item.food.name,
                                style: AppStyles.itemTitle,
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${item.food.price}${LocaleKeys.usd.tr()}',
                                    style: AppStyles.itemPrice,
                                  ),
                                  const SizedBox(
                                      width: AppSizes.horizontalPadding), // Adjusted size
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.black87,
                                        ),
                                        onPressed: () {
                                          if (item.quantity == 1) {
                                            foodBloc.add(DeleteFood(item));
                                          } else {
                                            foodBloc.add(DecrementCountEvent(item));
                                          }
                                        },
                                      ),
                                      Text(
                                        item.quantity.toString(),
                                        style: AppStyles.itemCount,
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.black87,
                                        ),
                                        onPressed: () {
                                          foodBloc.add(IncrementCountEvent(item));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (state.foods.isNotEmpty)
                        ZoomTapAnimation(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailScreen(
                                  foodItems: state.foods,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(16.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSizes.verticalPadding * 3),
                              child: Center(
                                child: Text(
                                  "${LocaleKeys.orderNow.tr()} / ${state.totalValue} ${LocaleKeys.usd.tr()}",
                                  style: AppStyles.orderButton, // Adjusted size
                                ),
                              ),
                            ),
                          ),
                        ),
                      Gap(TDevice.getBottomNavigationBarHeight() * 1.5)
                    ],
                  );
          } else {
            return Center(child: Text('Unknown state: $state'));
          }
        },
      ),
    );
  }
}
