import 'package:doni_pizza/business_logic/blocs/order_bloc/order_remote_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
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

  String getFutureTime(DateTime dateTime) {
    final formattedTime = DateFormat('HH:mm').format(dateTime);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: BlocBuilder<OrderRemoteBloc, OrderRemoteState>(
          builder: (context, state) {
            if (state is OrderRemoteInitial) {
              Center(child: Text(LocaleKeys.noOrder.tr()));
            } else if (state is OrdersFetchedState) {
              final currentOrder = state.orders
                  .where((element) =>
                      element.userId == context.read<AuthCubit>().state.user?.uid &&
                      !(element.status == OrderStatus.delivered ||
                          element.status == OrderStatus.canceled))
                  .toList();

              return (currentOrder.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final order = currentOrder[index];
                        return ExpansionTile(
                          childrenPadding: EdgeInsets.symmetric(vertical: 10.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${order.address}",
                                    style:
                                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),

                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              Text(
                                "#${order.id.toString().split("-").first}",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                            ],
                          ),
                          subtitle: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${LocaleKeys.deliveryTime.tr()} ${getCurrentTime(currentOrder.first.timestamp)} - ${getFutureTime(currentOrder.first.timestamp.add(Duration(minutes: 40)))}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Gap(10),
                                  Text(
                                    LocaleKeys.currentOrder.tr(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Sora',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                    // textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: [
                            ConditionIcons(currentOrder: order.status,),
                          ],
                        );
                      },
                      itemCount: currentOrder.length,
                    );
            }
            return Center(
              child: Text('Current state: $state'),
            );
          },
        ),
      ),
    );
  }
}


class StatusIcon extends StatelessWidget {
  const StatusIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.isActive, required this.isCurrentIndex,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final bool isActive;
  final bool isCurrentIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
      padding: EdgeInsets.all(isCurrentIndex ? 18 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isActive ? Colors.indigo.shade300 : Colors.grey.shade200,
      ),
      child: Icon(
        icon,
        color: isCurrentIndex ? Colors.white :isActive? Colors.yellow : Colors.black
      ),
    );
  }
}


class ConditionIcons extends StatelessWidget {
  const ConditionIcons({
    Key? key,
    required this.currentOrder,
  }) : super(key: key);

  final OrderStatus currentOrder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatusIcon(
          icon: Icons.watch_later,
          color: Colors.indigo.shade300,
          isActive: currentOrder.index >= OrderStatus.pending.index,
          isCurrentIndex: currentOrder.index == OrderStatus.pending.index,
        ),
        SizedBox(width: 20),
        StatusIcon(
          icon: Icons.restaurant_menu,
          color: Colors.indigo.shade300,
          isActive: currentOrder.index >= OrderStatus.preparing.index,
          isCurrentIndex: currentOrder.index == OrderStatus.preparing.index,
        ),
        SizedBox(width: 20),
        StatusIcon(
          icon: Icons.directions_run,
          color: Colors.indigo.shade300,
          isActive: currentOrder.index >= OrderStatus.onRoute.index,
          isCurrentIndex:
          currentOrder.index == OrderStatus.onRoute.index,
        ),
        SizedBox(width: 20),
        StatusIcon(
          icon: Icons.file_download_done,
          color: Colors.indigo.shade300,
          isActive: currentOrder.index >= OrderStatus.delivered.index,
          isCurrentIndex: currentOrder.index == OrderStatus.delivered.index,
        ),
      ],
    );
  }
}

