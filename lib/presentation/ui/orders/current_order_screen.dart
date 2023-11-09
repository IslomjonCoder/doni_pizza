import 'package:doni_pizza/business_logic/blocs/order_bloc/order_remote_bloc.dart';
import 'package:doni_pizza/utils/constants/enums.dart';
import 'package:doni_pizza/utils/icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../generated/locale_keys.g.dart';

class CurrentOrderScreen extends StatefulWidget {
  const CurrentOrderScreen({super.key});

  @override
  State<CurrentOrderScreen> createState() => _CurrentOrderScreenState();
}

class _CurrentOrderScreenState extends State<CurrentOrderScreen> {
  String getCurrentTime([DateTime? dateTime]) {
    final now = dateTime ?? DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(now);
    return formattedTime;
  }

  String getFutureTime() {
    final now = DateTime.now();
    final futureTime = now.add(const Duration(minutes: 40));
    final formattedTime = DateFormat('HH:mm').format(futureTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          BlocBuilder<OrderRemoteBloc, OrderRemoteState>(
            builder: (context, state) {
              print(state);
              if (state is OrderRemoteInitial) {
                Center(child: Text(LocaleKeys.noOrder.tr()));
              } else if (state is OrdersFetchedState) {
                final currentOrder = state.orders
                    .where((element) => element.status != OrderStatus.delivered)
                    .toList();

                return (currentOrder.isEmpty)
                    ? Center(
                        child: Column(
                        children: [
                          SvgPicture.asset(
                            AppImages.orderEmpty,
                          ),
                          const Gap(10),
                          Text(
                            LocaleKeys.noOrder.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Sora",
                            ),
                          ),
                        ],
                      ))
                    : Center(
                        child: Column(
                          children: [
                            Text(
                              "Yetkaziladigan vaqt: ${getCurrentTime()} - ${getFutureTime()}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            const Text(
                              "Buyurtmani Doni Pizza tomonidan tasdiqlash 3-5 daqiqa vaqt oladi.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 50),
                            const ConditionIcons()
                          ],
                        ),
                      );
              }
              return Center(
                child: Text('Current state: $state'),
              );
            },
          ),
        ]),
      ),
    );
  }
}

class ConditionIcons extends StatelessWidget {
  const ConditionIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderRemoteBloc, OrderRemoteState>(
      builder: (context, state) {
        if (state is OrdersFetchedState) {
          final currentOrder = state.orders.first.status;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          bottomLeft: Radius.circular(50.0),
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                      color: currentOrder.index >= OrderStatus.pending.index
                          ? Colors.indigo.shade300
                          : Colors.grey.shade200),
                  child: const Icon(
                    Icons.watch_later,
                    color: Colors.black,
                  )),
              Container(
                height: 20,
                width: 20,
                color: currentOrder.index >= OrderStatus.pending.index
                    ? Colors.indigo.shade300
                    : Colors.grey.shade200,
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    color: currentOrder.index >= OrderStatus.preparing.index
                        ? Colors.indigo.shade300
                        : Colors.grey.shade200),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.black,
                ),
              ),
              Container(
                height: 20,
                width: 20,
                color: currentOrder.index >= OrderStatus.preparing.index
                    ? Colors.indigo.shade300
                    : Colors.grey.shade200,
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    color: currentOrder.index >= OrderStatus.onRoute.index
                        ? Colors.indigo.shade300
                        : Colors.grey.shade200),
                child: const Icon(
                  Icons.directions_run,
                  color: Colors.black,
                ),
              ),
              Container(
                height: 20,
                width: 20,
                color: currentOrder.index >= OrderStatus.onRoute.index
                    ? Colors.indigo.shade300
                    : Colors.grey.shade200,
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        topRight: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                    color: currentOrder.index >= OrderStatus.delivered.index
                        ? Colors.greenAccent.shade700

                        : Colors.grey.shade200),
                child: const Icon(
                  Icons.file_download_done,
                  color: Colors.black,
                ),
              ),
            ],
          );
        }
        return Center(
          child: Text('Current state: $state'),
        );
      },
    );
  }
}
