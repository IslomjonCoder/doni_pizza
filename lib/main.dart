import 'package:doni_pizza/business_logic/auth_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/cart_bloc/order_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/cart_bloc/state_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/food_bloc/food_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/order_bloc/order_remote_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/promotion_bloc/promotion_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/category_cubit/category_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/category_index_cubit/category_index_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/food_cubit/food_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/tab_cubit/tab_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/user_data_cubit.dart';
import 'package:doni_pizza/data/models/category_model.dart';
import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/models/order_item.dart';
import 'package:doni_pizza/data/models/user_model.dart';
import 'package:doni_pizza/data/repositories/auth_repo.dart';
import 'package:doni_pizza/data/repositories/category_repo.dart';
import 'package:doni_pizza/data/repositories/food_repo.dart';
import 'package:doni_pizza/data/repositories/promotion_repo.dart';
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
import 'package:hive_flutter/hive_flutter.dart';

//Add code comments for the code snippet
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  Hive.registerAdapter(OrderItemAdapter()); // Register the generated type adapter
  Hive.registerAdapter(FoodItemAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<FoodItem>('foodItems');
  await Hive.openBox<OrderItem>('orderItems');
  runApp(EasyLocalization(
      assetLoader: const CodegenLoader(),
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('uz')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp()));
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthRepository authRepository = AuthRepository();
  final UserRepository userRepository = UserRepository();
  final CategoryRepository categoryRepository = CategoryRepository();
  final FoodItemRepository foodItemRepository = FoodItemRepository();
  final PromotionRepository promotionRepository = PromotionRepository();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
        BlocProvider<OrderRemoteBloc>(create: (context) => OrderRemoteBloc()),
        BlocProvider<FoodBloc>(create: (context) => FoodBloc()..add(LoadTodosEvent())),
        BlocProvider<TabCubit>(create: (context) => TabCubit()),
        BlocProvider<PromotionBloc>(
            create: (context) => PromotionBloc(promotionRepository)..add(GetAllPromotions())),
        BlocProvider<FoodBlocRemote>(
            create: (context) => FoodBlocRemote(foodItemRepository)..add(GetAll())),
        BlocProvider<CategoryIndexCubit>(create: (context) => CategoryIndexCubit()),
        BlocProvider<CategoryCubit>(create: (context) => CategoryCubit(categoryRepository)),
        BlocProvider<FoodCubit>(create: (context) => FoodCubit(foodItemRepository)),
        BlocProvider<UserDataCubit>(create: (context) => UserDataCubit()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository)),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          indicatorColor: Colors.black,
            appBarTheme: const AppBarTheme(
                centerTitle: true,
                titleTextStyle: TextStyle(color: AppColors.c1E293B),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.c475569))),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
      ),
    );
  }
}
// write login app design
