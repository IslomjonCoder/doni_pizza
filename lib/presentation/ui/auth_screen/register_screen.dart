import 'package:doni_pizza/presentation/ui/auth_screen/welcome_screen.dart';
import 'package:doni_pizza/utils/colors.dart';
import 'package:doni_pizza/utils/constants/sizes.dart';
import 'package:doni_pizza/utils/constants/texts.dart';
import 'package:doni_pizza/utils/fonts/fonts.dart';
import 'package:doni_pizza/utils/icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doni_pizza/business_logic/auth_bloc.dart';
import 'package:doni_pizza/business_logic/auth_event.dart';
import 'package:doni_pizza/business_logic/auth_state.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/widgets/global_textfield.dart';
import 'package:doni_pizza/utils/dialogs/snackbar_dialogs.dart';

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
    if (passwordController.text.length < TSizes.customPaddingSm) {
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
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
                height: 143,
                child: Center(
                  child: Text(TTexts.register,
                      style: TFonts.titleScreen.copyWith(color: AppColors.c1E293B)),
                )),
            Column(
              children: [
                GlobalTextField(
                  controller: nameController,
                  hintText: 'Doni Pizza',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  caption: LocaleKeys.name.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.enter_name.tr();
                    }
                    return null;
                  },
                ),
                GlobalTextField(
                  controller: phoneController,
                  hintText: '+(998) 99-999-99',
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
                GlobalTextField(
                  hintText: '********',
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  caption: LocaleKeys.password.tr(),
                  controller: passwordController,
                  validator: passwordsMatch,
                  max: 1,
                ),
                GlobalTextField(
                  hintText: '********',
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  caption: LocaleKeys.confirmPassword.tr(),
                  controller: confirmPasswordController,
                  validator: passwordsMatch,
                  max: 1,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (passwordController.text == confirmPasswordController.text) {
                      context.read<AuthBloc>().add(RegisterEvent(
                            name: nameController.text.trim(),
                            phoneNumber: phoneController.text.trim(),
                            password: passwordController.text.trim(),
                          ));
                    }
                  }
                },
                style: ButtonStyles.roundedButtonStyle,
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
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(GoogleLoginEvent());
                },
                style: ButtonStyles.roundedButtonStyle,
                label: Text(
                  'Login with Google',
                  style: ButtonStyles.buttonTextStyle.copyWith(color: AppColors.c1E293B),
                ),
                icon: BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.signInWithGoogleStatus == Status.loading) {
                      return const SizedBox.square(
                        dimension: TSizes.customPaddingSm,
                        child: CircularProgressIndicator(color: AppColors.c2B8761),
                      );
                    }
                    return SvgPicture.asset(AppImages.google);
                  },
                  listener: (BuildContext context, AuthState state) {
                    if (state.error != null) {
                      TDialog.showAlert(context: context, message: state.error!);
                    }
                  },
                ),
              ),
            ),
            // const SizedBox(height: TSizes.customLetsInSpacing),
          ],
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
