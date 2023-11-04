import 'package:doni_pizza/business_logic/cubits/tab_cubit/tab_cubit.dart';
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
      bottomNavigationBar: DotNavigationBar(
        backgroundColor: Colors.grey[300],
        currentIndex: context.watch<TabCubit>().state,
        onTap: context.read<TabCubit>().changeTab,
        unselectedItemColor: Colors.grey,
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.home),
            selectedColor: Colors.black,
          ),
          DotNavigationBarItem(
            icon: const Badge(
              label: Text('7'),
              child: Icon(Icons.shopping_cart),
            ),
            selectedColor: Colors.black,
          ),
          DotNavigationBarItem(
            icon: const Badge(
              label: Text('1'),
              child: Icon(Icons.access_time_outlined),
            ),
            selectedColor: Colors.black,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.person),
            selectedColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
