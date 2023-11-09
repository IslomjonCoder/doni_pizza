import 'package:doni_pizza/business_logic/cubits/tab_cubit/tab_cubit.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class TabBox extends StatefulWidget {
  const TabBox({super.key});

  @override
  TabBoxState createState() => TabBoxState();
}

class TabBoxState extends State<TabBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: context.watch<TabCubit>().state,
        children: context.read<TabCubit>().pages,
      ),
      bottomNavigationBar: StylishBottomBar(
        option: BubbleBarOptions(
          barStyle: BubbleBarStyle.horizotnal,
          bubbleFillStyle: BubbleFillStyle.fill,
          opacity: 0.5,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.menu),
            title: Text(LocaleKeys.menu.tr(),style: const TextStyle(color: Colors.white,fontFamily: 'Sora',fontWeight: FontWeight.w600),),
            backgroundColor: Colors.black,
            selectedIcon: const Icon(Icons.menu),
          ),
          BottomBarItem(
            icon: const Icon(Icons.shopping_cart),
            title: Text(LocaleKeys.cart.tr(),style: const TextStyle(color: Colors.white,fontFamily: 'Sora',fontWeight: FontWeight.w600),),
            backgroundColor: Colors.red,
            selectedIcon: const Icon(Icons.shopping_cart),
          ),
          BottomBarItem(
            icon: const Icon(Icons.watch_later_outlined),
            title: Text(LocaleKeys.orders.tr(),style: const TextStyle(color: Colors.white,fontFamily: 'Sora',fontWeight: FontWeight.w600),),
            backgroundColor: Colors.blue[900],
            selectedIcon: const Icon(Icons.watch_later),

          ),
          BottomBarItem(
            icon: const Icon(Icons.person),
            title: Text(LocaleKeys.profile.tr(),style: const TextStyle(color: Colors.white,fontFamily: 'Sora',fontWeight: FontWeight.w600),),
            backgroundColor: Colors.black,
            selectedIcon: const Icon(Icons.person),
          ),
        ],
        hasNotch: true,
        currentIndex: context
            .watch<TabCubit>()
            .state,
        onTap: context
            .read<TabCubit>()
            .changeTab,
      ),
    );
  }
}
