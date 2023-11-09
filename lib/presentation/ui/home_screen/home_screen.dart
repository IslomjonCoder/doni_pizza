import 'package:cached_network_image/cached_network_image.dart';
import 'package:doni_pizza/business_logic/blocs/cart_bloc/state_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/food_bloc/food_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/category_cubit/category_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/category_index_cubit/category_index_cubit.dart';
import 'package:doni_pizza/data/models/category_model.dart';
import 'package:doni_pizza/data/models/food_model.dart';
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
import 'package:gap/gap.dart';
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



  // final colors = <Color>[
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () async {
      //       print('Started');
      //       final promotion = Promotion(
      //         id: '2',
      //         title: 'Limited Time Deal',
      //         description: 'Try our new menu items with exclusive discounts.',
      //         imageUrl: 'https://example.com/promotion2.jpg',
      //       );
      //
      //       final image = await THelperFunctions.getImageFromGallery();
      //       if (image != null) {
      //         if (!context.mounted) return;
      //         context.read<PromotionBloc>().add(UpdatePromotion(promotion, image));
      //       }
      //       print('Ended');
      //     },
      //     child: const Text("GO")),
      backgroundColor: Colors.white,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
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
                  context.read<FoodBlocRemote>().add(SearchFoodItem(query));
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
                      context.read<FoodBlocRemote>().add(GetAll());
                      searchController.clear();
                      setState(() {
                        isSearching = false;
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
              height: 50,
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
                              ? context.read<FoodBlocRemote>().add(GetAll())
                              : context
                                  .read<FoodBlocRemote>()
                                  .add(GetFoodsByCategory(category.id!));
                        },
                        child: Card(
                          shadowColor: Colors.black,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                color: context.read<CategoryIndexCubit>().state == index
                                    ? Colors.black
                                    : Colors.transparent),
                          ),
                          color: context.watch<CategoryIndexCubit>().state == index
                              ? Colors.black
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                  color: context.watch<CategoryIndexCubit>().state == index
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
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
            const Gap(10),
            const Promotions(),
            // const Gap(TSizes.md),
            // BlocBuilder<PromotionBloc, PromotionState>(
            //   builder: (context, state) {
            //     if (state is PromotionLoading) {
            //       return Shimmer.fromColors(
            //         baseColor: Colors.grey[300]!,
            //         highlightColor: Colors.grey[100]!,
            //         child: Container(),
            //       );
            //     } else if (state is PromotionLoaded) {
            //       return CarouselSlider(
            //           options: CarouselOptions(height: 150, autoPlay: true),
            //           items: state.promotions.map((promotion) {
            //             return Container(
            //                 margin: const EdgeInsets.symmetric(horizontal: 10),
            //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            //                 child: CachedNetworkImage(
            //                   imageUrl: promotion.imageUrl,
            //                 ));
            //           }).toList());
            //     } else if (state is PromotionError) {
            //       return Center(child: Text(state.error));
            //     }
            //     return Center(child: Text(state.toString()));
            //   },
            // ),
            // const Gap(TSizes.md),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const Divider()
              ],
            ),
            BlocBuilder<FoodBlocRemote, FoodStateRemote>(
              builder: (context, state) {
                if (state is FetchFoodSuccess) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.food.length,
                    itemBuilder: (context, index) {
                      final item = state.food[index];
                      return Card(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            decoration: BoxDecoration(
                              // border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 10.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context).size.height / 7,
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width / 3.5,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16.0),
                                            image:  DecorationImage(
                                              fit: BoxFit.scaleDown,
                                              image: CachedNetworkImageProvider(item.imageUrl),
                                            ),
                                          )),
                                      const SizedBox(width: 5.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 10,
                                            ),
                                            const Text(
                                              'Tanlang savatga qo\'shing va sotib oling!',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 2,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${item.price.toStringAsFixed(2)} ${LocaleKeys.usd.tr()}',
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      fontFamily: 'Sora'),
                                                ),
                                                ZoomTapAnimation(
                                                  onTap: () {
                                                    context
                                                        .read<FoodBloc>()
                                                        .add(AddFoodEvent(item));
                                                    Fluttertoast.showToast(
                                                      msg: LocaleKeys.successfully_added_to_cart
                                                          .tr(),
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      backgroundColor: Colors.white,
                                                      textColor: Colors.black,
                                                      fontSize: 16.0,
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    margin: const EdgeInsets.only(bottom: 8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Icon(
                                                      Icons.shopping_cart,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                } else if (state is FetchFoodLoading || state is FoodInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FetchFoodFailure) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('Unknown state: $state'));
              },
            ),
            const SizedBox(
              height: 100.0,
            )
          ],
        ),
      ),
    );
  }
}

// Hero(
// tag: 'product_${item.name}',
// child: Image.asset(
// item.imageUrl,
// errorBuilder: (context, error, stackTrace) {
// return Image.asset(
// AppImages.burger,
// );
// },
// ),
// ),
