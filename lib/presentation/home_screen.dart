// import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
// import 'package:doni_pizza/business_logic/cubits/food_cubit/food_cubit.dart';
// import 'package:doni_pizza/data/models/food_model.dart';
// import 'package:doni_pizza/data/repositories/category_repo.dart';
// import 'package:doni_pizza/data/repositories/food_repo.dart';
// import 'package:doni_pizza/utils/constants/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final FoodItemRepository foodItemRepository = FoodItemRepository();
//     final CategoryRepository categoryRepository = CategoryRepository();
//     final authCubit = BlocProvider.of<AuthCubit>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Screen'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             onPressed: () {
//               // authCubit.changeState(AuthState.unauthenticated);
//               print(authCubit.state.name);
//               authCubit.logout();
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<FoodCubit, List<FoodItem>>(
//         builder: (context, state) {
//           return state.isEmpty
//               ? const Center(
//                   child: Text('Empty'),
//                 )
//               : ListView.builder(
//                   itemBuilder: (context, index) {
//                     final food = state[index];
//                     return ListTile(
//                       title: Text(food.name),
//                       subtitle: Text(food.price.toString()),
//                     );
//                   },
//                   itemCount: state.length,
//                 );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           print('Start');
//           for (var element in categories) {
//             await categoryRepository.addCategory(element);
//           }
//           // await context.read<FoodCubit>().fetchFoodItems();
//           print('Finish');
//         },
//         child: const Text('GO'),
//       ),
//     );
//   }
// }
