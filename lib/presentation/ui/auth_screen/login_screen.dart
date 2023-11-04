import 'package:doni_pizza/business_logic/auth_bloc.dart';
import 'package:doni_pizza/business_logic/auth_event.dart';
import 'package:doni_pizza/business_logic/auth_state.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/widgets/global_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:doni_pizza/presentation/ui/auth_screen/welcome_screen.dart';

// import 'package:doni_pizza/generated/locale_keys.g.dart';

// import 'package:doni_pizza/presentation/ui/profile_screen/widget/select_language.dart';
// import 'package:doni_pizza/presentation/widgets/global_textfield.dart';
import 'package:doni_pizza/utils/colors.dart';
import 'package:doni_pizza/utils/constants/sizes.dart';
import 'package:doni_pizza/utils/constants/texts.dart';
import 'package:doni_pizza/utils/dialogs/snackbar_dialogs.dart';
import 'package:doni_pizza/utils/fonts/fonts.dart';
import 'package:doni_pizza/utils/formatters/formatter.dart';
import 'package:doni_pizza/utils/icons.dart';
import 'package:doni_pizza/utils/logging/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.signInWithEmailAndPasswordStatus == Status.success) {
            TLoggerHelper.info("Success");
          } else if (state.signInWithEmailAndPasswordStatus == Status.failure) {
            // Display an error message to the user
            TDialog.showAlert(context: context, message: state.error!);
          }
        },
        child: _buildLoginForm(context),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
                height: 143,
                child: Center(
                  child: Text(TTexts.login,
                      style: TFonts.titleScreen.copyWith(color: AppColors.c1E293B)),
                )),
            Column(
              children: [
                GlobalTextField(
                    hintText: '+(998) 99-999-99',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    caption: LocaleKeys.phone_number.tr(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.errorPassword.tr();
                      }
                      return null;
                    }),
                const Gap(TSizes.sm),
                GlobalTextField(
                  hintText: '********',
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  caption: LocaleKeys.password.tr(),
                  max: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.errorPassword.tr();
                    }
                    return null;
                  },
                ),
              ],
            ),
            const Gap(TSizes.lg),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state.signInWithEmailAndPasswordStatus == Status.loading;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ButtonStyles.elevatedButtonStyle,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(LoginEvent(
                            phoneNumber:
                                TFormatter.convertPhoneNumberToEmail(_phoneController.text.trim()),
                            password: _passwordController.text.trim()));
                      }
                    },
                    icon: isLoading
                        ? const SizedBox.square(
                            dimension: TSizes.sm,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ))
                        : const SizedBox(),
                    label: Text(
                      TTexts.login,
                      style: ButtonStyles.buttonTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            const Gap(TSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: Divider(endIndent: 16)),
                Text(
                  LocaleKeys.or.tr(),
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sora'),
                ),
                const Expanded(child: Divider(indent: 16)),
              ],
            ),
            const Gap(TSizes.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(GoogleLoginEvent());
                },
                style: ButtonStyles.roundedButtonStyle,
                label: Text(
                  TTexts.loginWithGoogle,
                  style: ButtonStyles.buttonTextStyle.copyWith(color: AppColors.c1E293B),
                ),
                icon: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
                  if (state.signInWithGoogleStatus == Status.loading) {
                    return const SizedBox.square(
                        dimension: TSizes.sm,
                        child: CircularProgressIndicator(color: AppColors.c2B8761));
                  }
                  return SvgPicture.asset(AppImages.google);
                }, listener: (BuildContext context, AuthState state) {
                  if (state.error != null) {
                    TDialog.showAlert(context: context, message: state.error!);
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
