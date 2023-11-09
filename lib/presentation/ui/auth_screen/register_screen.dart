import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doni_pizza/business_logic/cubits/user_data_cubit.dart';
import 'package:doni_pizza/utils/colors.dart';
import 'package:doni_pizza/utils/constants/sizes.dart';
import 'package:doni_pizza/utils/constants/texts.dart';
import 'package:doni_pizza/utils/fonts/fonts.dart';
import 'package:doni_pizza/utils/icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doni_pizza/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/widgets/global_textfield.dart';
import 'package:doni_pizza/utils/dialogs/snackbar_dialogs.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? passwordsMatch(String? value) {
    if (passwordController.text.length < 8) {
      return LocaleKeys.passwordLengthError.tr();
    }

    if (value != passwordController.text) {
      return LocaleKeys.password_does_not_match.tr();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthUserState>(
        listener: (context, state) {
          if (state.registerWithEmailAndPasswordStatus == Status.failure) {
            // Display an error message to the user
            TDialog.showAlert(context: context, message: state.error!);
          } else if (state.registerWithEmailAndPasswordStatus == Status.success) {
            // Handle success event, if needed
          }
        },
        child: _buildRegistrationForm(context),
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Container(
      height: context.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1520201163981-8cc95007dd2a?q=80&w=2736&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')
          )
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6)
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Gap(kToolbarHeight*2),
                SizedBox(
                    height: 143,
                    child: Center(
                      child: Text(TTexts.register,
                          style: TFonts.titleScreen.copyWith(color: AppColors.white)),
                    )),
                Column(
                  children: [
                    GlobalTextField(
                      isDark: true,
                      controller: nameController,
                      hintText: 'Doni Pizza',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      caption: LocaleKeys.name.tr(),
                      onChanged: (value) {
                        context.read<UserDataCubit>().updateName(value.trim());
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.enter_name.tr();
                        }
                        return null;
                      },
                    ),
                    GlobalTextField(
                      isDark: true,
                      controller: phoneController,
                      hintText: '+(998) 99-999-99',
                      onChanged: (value) {
                        context.read<UserDataCubit>().updatePhoneNumber(value);
                      },
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      caption: LocaleKeys.phone_number.tr(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.errorPhoneNumber.tr();
                        }
                        return null;
                      },
                    ),

                  ],
                ),
                const Gap(kToolbarHeight/2),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(TSizes.sm)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TSizes.lg),
                          ),
                        )
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(RegisterWithGoogleEvent());
                      }
                    },
                    label: Text(
                      context.watch<AuthBloc>().state.registerWithEmailAndPasswordStatus ==
                              Status.loading
                          ? TTexts.loading
                          : LocaleKeys.signUp.tr(),
                      style: Styles.buttonTextStyle,
                    ),
                    icon: context.read<AuthBloc>().state.registerWithEmailAndPasswordStatus ==
                            Status.loading
                        ? const SizedBox(
                            height: TSizes.customPaddingSm,
                            width: TSizes.customPaddingSm,
                            child: CircularProgressIndicator(color: Colors.black,),
                          )
                        :  SvgPicture.asset(AppImages.google),
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

class Styles {
  static const TextStyle titleTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Sora',
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static const TextStyle descriptionTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Sora',
    fontSize: 18,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Sora',
    fontWeight: FontWeight.bold,
  );

  static final ButtonStyle roundedButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.all(16),
    ),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    overlayColor: MaterialStateProperty.all<Color>(Colors.grey),
  );
}
