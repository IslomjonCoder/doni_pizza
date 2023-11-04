import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/presentation/home_screen.dart';
import 'package:doni_pizza/presentation/ui/auth_screen/welcome_screen.dart';
import 'package:doni_pizza/presentation/ui/tab_box/tab_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouterApp extends StatelessWidget {
  const RouterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state == AuthState.unauthenticated) {
          return const WelcomeScreen();
        } else {
          return const TabBox();
        }
      },
      listener: (BuildContext context, AuthState state) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const RouterApp(),
          ),
          (route) => false,
        );
      },
    );
  }
}
