import 'package:doni_pizza/business_logic/blocs/cart_bloc/order_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/cart_bloc/state_bloc.dart';
import 'package:doni_pizza/data/models/order_item.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/widgets/global_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetailScreen extends StatefulWidget {
  final List<OrderItem> foodItems;

  const OrderDetailScreen({super.key, required this.foodItems});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  OrderRecipient _selectedRecipient = OrderRecipient.me;

  TextEditingController addressController = TextEditingController();
  TextEditingController recipientPhoneController = TextEditingController();

  double calculateTotalPrice(List<OrderItem> foodItems) =>
      foodItems.fold(0, (previousValue, element) => previousValue + element.totalPrice);

  // void orderNow({double? newTotalCost}) async {
  //   final orderDate = DateTime.now();
  //
  //   final foodNames = widget.foodItems.map((item) => item.name).join(', ');
  //
  //   final order = OrderModel(
  //     foodNames: foodNames,
  //     totalCost: newTotalCost ?? 0.0,
  //     timestamp: orderDate.toString(),
  //   );
  //
  //   context.read<OrderBloc>().add(AddOrderEvent(order));
  // }

  bool showLottie = false;

  // void placeOrderAndDeleteCart(List<FoodModel> foodItems) async {
  //   setState(() {
  //     showLottie = true;
  //   });
  //
  //   await Future.delayed(const Duration(seconds: 4));
  //
  //   double newTotalCost = calculateTotalPrice(foodItems);
  //
  //   orderNow(newTotalCost: newTotalCost);
  //
  //   Fluttertoast.showToast(
  //     timeInSecForIosWeb: 3,
  //     msg: LocaleKeys.orderSuccess.tr(),
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: ToastGravity.CENTER_RIGHT,
  //     backgroundColor: Colors.white,
  //     textColor: Colors.black,
  //     fontSize: 22.0,
  //   );
  //   // ignore: use_build_context_synchronously
  //   context.read<FoodBloc>().add(DeleteFoods());
  //
  //   setState(() {
  //     showLottie = false;
  //   });
  // }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            LocaleKeys.orderDetail.tr(),
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
        ),
        body: Center(
          child: Text('Order'),
        ) /*SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    title: Text(LocaleKeys.recipient.tr(), style: const TextStyle(fontSize: 18)),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                RadioListTile<OrderRecipient>(
                  activeColor: Colors.black,
                  title: Text(LocaleKeys.me.tr()),
                  value: OrderRecipient.me,
                  groupValue: _selectedRecipient,
                  onChanged: (value) {
                    setState(() {
                      _selectedRecipient = value!;
                    });
                  },
                ),
                RadioListTile<OrderRecipient>(
                  activeColor: Colors.black,
                  title: Text(LocaleKeys.another.tr()),
                  value: OrderRecipient.lovedOne,
                  groupValue: _selectedRecipient,
                  onChanged: (value) {
                    setState(() {
                      _selectedRecipient = value!;
                    });
                  },
                ),
                Visibility(
                  visible: _selectedRecipient == OrderRecipient.lovedOne,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GlobalTextField(
                      hintText: LocaleKeys.recipientPhoneNumber.tr(),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      caption: LocaleKeys.mandatory.tr(),
                      validator: (value) {
                        if (_selectedRecipient == OrderRecipient.lovedOne && value!.isEmpty) {
                          return LocaleKeys.phone_number.tr();
                        }
                        return null;
                      },
                      controller: recipientPhoneController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      GlobalTextField(
                        hintText: LocaleKeys.enterAddress.tr(),
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        caption: LocaleKeys.mandatory.tr(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return LocaleKeys.addressMandatory.tr();
                          }
                          return null;
                        },
                        controller: addressController,
                      ),
                      ListTile(
                        title: Text(LocaleKeys.paymentMethod.tr(),
                            style: const TextStyle(fontSize: 18)),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ],
                  ),
                ),
                RadioListTile<PaymentMethod>(
                  activeColor: Colors.black,
                  title: Text(LocaleKeys.cashOnDelivery.tr()),
                  value: PaymentMethod.cash,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                RadioListTile<PaymentMethod>(
                  activeColor: Colors.black,
                  title: Text(LocaleKeys.cardOnDelivery.tr()),
                  value: PaymentMethod.card,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        placeOrderAndDeleteCart(widget.foodItems);
                        Future.delayed(const Duration(seconds: 4), () {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: showLottie
                              ? const CupertinoActivityIndicator()
                              : Text(LocaleKeys.confirmOrder.tr()),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ))*/
        );
  }
}

enum PaymentMethod { cash, card }

enum OrderRecipient { me, lovedOne }
