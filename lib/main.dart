import 'package:doni_pizza/business_logic/auth_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/cart_bloc/order_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/category_cubit/category_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/category_index_cubit/category_index_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/food_cubit/food_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/tab_cubit/tab_cubit.dart';
import 'package:doni_pizza/data/repositories/auth_repo.dart';
import 'package:doni_pizza/data/repositories/category_repo.dart';
import 'package:doni_pizza/data/repositories/food_repo.dart';
import 'package:doni_pizza/data/repositories/user_repo.dart';
import 'package:doni_pizza/firebase_options.dart';
import 'package:doni_pizza/generated/codegen_loader.g.dart';
import 'package:doni_pizza/presentation/ui/splash_screen/splash_screen.dart';
import 'package:doni_pizza/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(EasyLocalization(
      assetLoader: const CodegenLoader(),
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('uz')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthRepository authRepository = AuthRepository();
  final UserRepository userRepository = UserRepository();
  final CategoryRepository categoryRepository = CategoryRepository();
  final FoodItemRepository foodItemRepository = FoodItemRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
        BlocProvider<TabCubit>(create: (context) => TabCubit()),
        BlocProvider<CategoryIndexCubit>(create: (context) => CategoryIndexCubit()),
        BlocProvider<CategoryCubit>(create: (context) => CategoryCubit(categoryRepository)),
        BlocProvider<FoodCubit>(create: (context) => FoodCubit(foodItemRepository)),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository)),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                centerTitle: true,
                titleTextStyle: TextStyle(color: AppColors.c1E293B),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.c475569))),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
