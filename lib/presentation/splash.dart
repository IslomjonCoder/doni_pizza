import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/presentation/router_app.dart';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthCubit authCubit = AuthCubit();

  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const RouterApp()));
      // final state = authCubit.state;
      // if (state == AuthState.unauthenticated) {
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (_) => const WelcomeScreen()));
      // } else {
      //   Navigator.of(context)
      //       .pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
