import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:doni_pizza/business_logic/blocs/order_bloc/order_remote_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/utils/constants/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../business_logic/blocs/cart_bloc/order_bloc.dart';
import '../../../generated/locale_keys.g.dart';
import 'current_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: [
            Tab(
              child: Text(
                LocaleKeys.current_orders.tr(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Tab(
              child: Text(
                LocaleKeys.all_orders.tr(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const CurrentOrderScreen(),
          BlocBuilder<OrderRemoteBloc, OrderRemoteState>(
            builder: (context, state) {
              if (state is OrderLoadingState) {
                return const Center(child: CircularProgressIndicator(color: Colors.black));
              } else if (state is OrdersFetchedState) {
                final successOrders = state.orders
                    .where((element) =>element.userId == context.read<AuthCubit>().state.user?.uid
                         &&
                    (element.status == OrderStatus.delivered ||
                            element.status == OrderStatus.canceled))
                    .toList();
                return successOrders.isEmpty
                    ? Center(child: Text(LocaleKeys.noOrder.tr()))
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: successOrders.length,
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1, color: Colors.black);
                        },
                        itemBuilder: (context, index) {
                          final order = successOrders[index];
                          final timestamp = DateTime.parse(order.timestamp.toString());
                          final formattedTimestamp =
                              DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
                          return ListTile(
                            title: Text(
                              order.items.map((e) => e.food.name).join(', '),
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            trailing: Card(
                              color:
                                  order.status == OrderStatus.delivered ? Colors.green : Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  order.status.name.capitalizeFirst(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${order.totalPrice} ${LocaleKeys.usd.tr()}',
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                    fontFamily: 'Sora',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${LocaleKeys.ordered_at.tr()}: $formattedTimestamp',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
              }
              return Center(
                child: Text(
                  "Current state: $state",
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
