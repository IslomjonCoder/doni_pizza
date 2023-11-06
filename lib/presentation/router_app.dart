import 'package:doni_pizza/business_logic/auth_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/data/repositories/user_repo.dart';
import 'package:doni_pizza/presentation/home_screen.dart';
import 'package:doni_pizza/presentation/ui/auth_screen/welcome_screen.dart';
import 'package:doni_pizza/presentation/ui/tab_box/tab_box.dart';
import 'package:doni_pizza/utils/logging/logger.dart';
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
      listener: (BuildContext context, AuthState state) async {
        TLoggerHelper.info('state is $state');
        if (state == AuthState.authenticated) {
          final userModel = await UserRepository().getUserInfo();
          print('ok');
          if (!context.mounted) return;
          print('ok');
          context.read<AuthBloc>().state.copyWith(userModel: userModel);
          TLoggerHelper.info(context.read<AuthBloc>().state.toString());
        }
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
