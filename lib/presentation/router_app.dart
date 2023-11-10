import 'package:doni_pizza/business_logic/blocs/cart_bloc/state_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/order_bloc/order_remote_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/tab_cubit/tab_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/user_data_cubit.dart';
import 'package:doni_pizza/data/database/user_service_hive.dart';
import 'package:doni_pizza/data/models/user_model.dart';
import 'package:doni_pizza/data/repositories/user_repo.dart';
import 'package:doni_pizza/presentation/ui/auth_screen/login_screen.dart';
import 'package:doni_pizza/presentation/ui/tab_box/tab_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouterApp extends StatelessWidget {
  const RouterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ,
      listenWhen: (previous, current) =>
      previous.status != current.status ,
      builder: (context, state) {
        if (state.status == AuthStateEnum.unauthenticated) {
          return const LoginScreen();
        } else {
          return const TabBox();
        }
      },
      listener: (BuildContext context, AuthState state) async {
        print('state changed');
        if (state.status == AuthStateEnum.authenticated) {
          context.read<OrderRemoteBloc>().init(state.user!.uid);
          final user = await UserRepository().getUserInfo();
          context.read<AuthCubit>().updateUserModel(user);
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

  Future<UserModel?> updateUserModelFromHiveOrFirestore(BuildContext context) async {
    // Check if UserModel exists in Hive
    final userModel = await HiveService.getUserModelFromHive();

    if (userModel != null) {
      return userModel; // Return UserModel from Hive if it exists
    } else {
      // If UserModel doesn't exist in Hive, fetch it from Firestore
      final userModelFromFirestore = await UserRepository().getUserInfo();

      // Store the UserModel in Hive
      await HiveService.saveUserModelToHive(userModelFromFirestore!);

      return userModelFromFirestore;
    }
  }
}
