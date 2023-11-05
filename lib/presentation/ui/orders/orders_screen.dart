import 'package:doni_pizza/business_logic/blocs/cart_bloc/order_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../utils/icons.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          LocaleKeys.orders.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        actions: [
          ZoomTapAnimation(
            onTap: () {
              context.read<OrderBloc>().add(ClearOrdersEvent());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Center(
                child: Text(
                  LocaleKeys.clear.tr(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // body: BlocBuilder<OrderBloc, OrderState>(
      //   builder: (context, state) {
      //     if (state is OrderInitialState || state is OrderLoadingState) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (state is OrderLoadedState) {
      //       final orders = state.orders;
      //       return orders.isEmpty
      //           ? Center(
      //               child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //                 SvgPicture.asset(AppImages.orderEmpty),
      //                 const SizedBox(height: 32.0),
      //                 Text(
      //                   LocaleKeys.noOrder.tr(),
      //                   textAlign: TextAlign.center,
      //                   style: const TextStyle(
      //                       fontFamily: 'Sora', fontSize: 20, fontWeight: FontWeight.bold),
      //                 ),
      //               ]),
      //             )
      //           : ListView.separated(
      //               physics: const BouncingScrollPhysics(),
      //               itemCount: orders.length,
      //               separatorBuilder: (context, index) {
      //                 return const Divider(
      //                   height: 1,
      //                   color: Colors.black,
      //                 );
      //               },
      //               itemBuilder: (context, index) {
      //                 final order = orders[index];
      //                 // final timestamp = DateTime.parse(order.timestamp);
      //                 final formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
      //                 return ListTile(
      //                   title: Text(
      //                     order.foodNames,
      //                     style: const TextStyle(
      //                       color: Colors.black,
      //                       fontFamily: 'Sora',
      //                       fontWeight: FontWeight.w700,
      //                     ),
      //                   ),
      //                   trailing: Text(
      //                     '${order.totalCost.toStringAsFixed(2)}${LocaleKeys.usd.tr()}',
      //                     style: const TextStyle(
      //                       color: Colors.indigo,
      //                       fontFamily: 'Sora',
      //                     ),
      //                   ),
      //                   subtitle: Row(
      //                     children: [
      //                       Text(
      //                         'Ordered at: $formattedTimestamp',
      //                         style: const TextStyle(
      //                           color: Colors.grey,
      //                           fontFamily: 'Sora',
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 );
      //               },
      //             );
      //     } else if (state is OrderErrorState) {
      //       return Center(child: Text('Error: ${state.errorMessage}'));
      //     } else {
      //       return const Text('Unknown state');
      //     }
      //   },
      // ),
    );
  }
}