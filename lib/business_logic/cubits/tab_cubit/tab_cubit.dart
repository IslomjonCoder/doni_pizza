import 'package:doni_pizza/presentation/ui/cart_screen/cart_screen.dart';
import 'package:doni_pizza/presentation/ui/home_screen/home_screen.dart';
import 'package:doni_pizza/presentation/ui/orders/orders_screen.dart';
import 'package:doni_pizza/presentation/ui/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabCubit extends Cubit<int> {
  TabCubit() : super(0);
  List<Widget> pages = [
    const HomeScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];
  void changeTab(int tabIndex) {
    emit(tabIndex);
  }
}
