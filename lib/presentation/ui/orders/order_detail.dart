import 'package:doni_pizza/business_logic/blocs/cart_bloc/state_bloc.dart';
import 'package:doni_pizza/business_logic/blocs/order_bloc/order_remote_bloc.dart';
import 'package:doni_pizza/business_logic/cubits/auth_cubit.dart';
import 'package:doni_pizza/business_logic/cubits/tab_cubit/tab_cubit.dart';
import 'package:doni_pizza/data/database/user_service_hive.dart';
import 'package:doni_pizza/data/models/order_item.dart';
import 'package:doni_pizza/data/models/order_model.dart';
import 'package:doni_pizza/data/models/user_model.dart';
import 'package:doni_pizza/data/repositories/user_repo.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/ui/tab_box/tab_box.dart';
import 'package:doni_pizza/presentation/widgets/global_textfield.dart';
import 'package:doni_pizza/utils/constants/enums.dart';
import 'package:doni_pizza/utils/helpers/uid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetailScreen extends StatefulWidget {
  final List<OrderItem> foodItems;

  const OrderDetailScreen({super.key, required this.foodItems});

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  OrderRecipient _selectedRecipient = OrderRecipient.me;

  TextEditingController addressController = TextEditingController();
  TextEditingController recipientPhoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool showLottie = false;

  double calculateTotalPrice() {
    return widget.foodItems.fold(0, (previousValue, element) => previousValue + element.totalPrice);
  }

  Future<void> placeOrder() async {
    if (_formKey.currentState!.validate()) {
      print('valid');
       UserModel? userModel;
      try{
        final userModel1 = await HiveService.getUserModelFromHive();
        userModel = userModel1;
      }catch(e){
        print(e.toString());
      }

      if (userModel != null) {

        print(userModel.name);
        if (!context.mounted) return;
        final order = OrderModel(
          timestamp: DateTime.now(),
          status: OrderStatus.pending,
          id: UidGenerator.generateUID(),
          userId: context.read<AuthCubit>().state.user?.uid ?? '',
          items: widget.foodItems,
          totalPrice: calculateTotalPrice(),
          phone: _selectedRecipient == OrderRecipient.me
              ? context.read<AuthCubit>().state.userModel!.phoneNumber
              : recipientPhoneController.text.trim(),
          paymentMethod: _selectedPaymentMethod,
          address: addressController.text,
          name: context.read<AuthCubit>().state.userModel!.name,
        );
        context.read<OrderRemoteBloc>().add(CreateOrderEvent(order));
        context.read<FoodBloc>().add(ClearCartEvent());
        context.read<TabCubit>().changeTab(2);
      }
      else{
        print('no user');
        final userModel = await UserRepository().getUserInfo();
        HiveService.saveUserModelToHive(userModel!);
        final order = OrderModel(
          timestamp: DateTime.now(),
          status: OrderStatus.pending,
          id: UidGenerator.generateUID(),
          userId: context.read<AuthCubit>().state.user?.uid ?? '',
          items: widget.foodItems,
          totalPrice: calculateTotalPrice(),
          phone: _selectedRecipient == OrderRecipient.me
              ? userModel.phoneNumber
              : recipientPhoneController.text.trim(),
          paymentMethod: _selectedPaymentMethod,
          address: addressController.text,
          name: userModel.name,
        );
        context.read<OrderRemoteBloc>().add(CreateOrderEvent(order));
        context.read<FoodBloc>().add(ClearCartEvent());
        context.read<TabCubit>().changeTab(2);
      }
      print('done');
    }
  }

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
      body: BlocListener<OrderRemoteBloc, OrderRemoteState>(
        listener: (context, state)async {
          if (state is OrderCreatedState|| state is OrdersFetchedState) {
            Fluttertoast.showToast(
              msg: LocaleKeys.orderCreated.tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
            );
            context.read<FoodBloc>().add(ClearCartEvent());
            context.read<TabCubit>().changeTab(2);
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const TabBox(),
                ),
                (route) => false);
          } else if (state is OrderRemoteErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
            );
          }
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
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
                    onTap: placeOrder,
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: context.watch<OrderRemoteBloc>().state is OrderRemoteLoading?
                               const CupertinoActivityIndicator(radius: 15,color: Colors.black,)
                              : Text(LocaleKeys.confirmOrder.tr()),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> loadingDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CupertinoActivityIndicator());
      },
      barrierDismissible: true);
}

enum OrderRecipient { me, lovedOne }
