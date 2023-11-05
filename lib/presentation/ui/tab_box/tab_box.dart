import 'package:doni_pizza/business_logic/cubits/tab_cubit/tab_cubit.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        backgroundColor: Colors.grey[300],
        currentIndex: context.watch<TabCubit>().state,
        onTap: context.read<TabCubit>().changeTab,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.grey[800],
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            // // selectedColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: const Badge(
              label: Text('7'),
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
            // selectedColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: const Badge(
              label: Text('1'),
              child: Icon(Icons.access_time_outlined),
            ),
            label: 'Orders',
            // selectedColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            // selectedColor: Colors.black,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
