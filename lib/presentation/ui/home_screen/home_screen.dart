import 'package:doni_pizza/business_logic/blocs/cart_bloc/state_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/category_cubit/category_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/category_index_cubit/category_index_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/food_cubit/food_cubit.dart';
import 'package:doni_pizza/data/models/category_model.dart';
import 'package:doni_pizza/data/models/food_model.dart';
import 'package:doni_pizza/data/repositories/category_repo.dart';
import 'package:doni_pizza/data/repositories/food_repo.dart';
import 'package:doni_pizza/presentation/ui/detail_screen/detail_screen.dart';
import 'package:doni_pizza/presentation/ui/home_screen/categories/categories.dart';
import 'package:doni_pizza/utils/constants/constants.dart';
import 'package:doni_pizza/utils/constants/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/ui/home_screen/promotions/promotions.dart';
import 'package:doni_pizza/presentation/widgets/global_textfield.dart';
import 'package:doni_pizza/utils/icons.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<FoodItem> allMenuItems = foodItems;

  bool isSearching = false;

  String selectedCategory = 'All';

  List<FoodItem> filteredFoods = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredFoods = List.from(allMenuItems);
  }

  void filterFoods(String query) {
    query = query.toLowerCase();
    setState(() {
      if (!isSearching) {
        searchController.clear();
        filteredFoods = List.from(allMenuItems);
      } else {
        filteredFoods = allMenuItems.where((food) {
          final name = food.name.toLowerCase();
          final description = food.description.toLowerCase();
          return name.contains(query) || description.contains(query);
        }).toList();
      }
    });
  }

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredFoods = allMenuItems;
      } else {
        filteredFoods = allMenuItems.where((item) => item.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        title: isSearching
            ? GlobalTextField(
                hintText: LocaleKeys.search.tr(),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                caption: '',
                controller: searchController,
                onChanged: (query) {
                  context.read<FoodCubit>().searchFoodItems(query);
                },
              )
            : Text(
                LocaleKeys.menu.tr(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
        actions: [
          isSearching
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        context.read<FoodCubit>().fetchFoodItems();
                        searchController.clear();
                        filterFoods('');
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                    icon: SvgPicture.asset(
                      AppImages.search,
                      width: 25,
                    ),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: BlocBuilder<CategoryCubit, List<CategoryModel>>(
                builder: (context, state) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                    // shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final category = state[index];
                      return GestureDetector(
                        onTap: () {
                          final all = context.read<CategoryIndexCubit>().state == index;
                          context.read<CategoryIndexCubit>().changeCategory(all ? -1 : index);
                          all
                              ? context.read<FoodCubit>().fetchFoodItems()
                              : context.read<FoodCubit>().getFoodItemsInCategory(category.id!);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: context.watch<CategoryIndexCubit>().state == index
                                    ? Colors.green
                                    : Colors.grey),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(category.name)),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: TSizes.sm);
                    },
                    itemCount: state.length,
                  );
                  /*return Categories(
                    imageUrls: state.map((e) => e.imageUrl).toList(),
                    categoryText: state.map((e) => e.name).toList(),
                    onSelectedCategory: updateCategory,
                    imagePaths: const [],
                  );*/
                },
              ),
            ),
            Promotions(),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(LocaleKeys.foods.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            BlocBuilder<FoodCubit, List<FoodItem>>(
              builder: (context, state) {
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.63,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    final item = state[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey,
                            Colors.white,
                            Colors.black,
                            Colors.black,
                            Colors.black
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ZoomTapAnimation(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(item: item),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Center(
                                    child: Hero(
                                      tag: 'product_${item.name}',
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.asset(
                                          item.imageUrl,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(AppImages.burger);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Sora',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item.description,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                        child: Text(
                                          '${item.price.toStringAsFixed(2)} ${LocaleKeys.usd.tr()}',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ZoomTapAnimation(
                                        onTap: () {
                                          context.read<FoodBloc>().add(AddFoodEvent(FoodItem(
                                                name: item.name,
                                                description: item.description,
                                                imageUrl: item.imageUrl,
                                                price: item.price,
                                                category: categories[0],
                                              )));
                                          Fluttertoast.showToast(
                                            msg: LocaleKeys.successfully_added_to_cart.tr(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.red,
                                          ),
                                          child: const Icon(Icons.add),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
