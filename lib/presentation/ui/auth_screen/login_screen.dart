import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doni_pizza/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:doni_pizza/generated/locale_keys.g.dart';
import 'package:doni_pizza/presentation/ui/auth_screen/register_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:doni_pizza/utils/colors.dart';
import 'package:doni_pizza/utils/constants/sizes.dart';
import 'package:doni_pizza/utils/constants/texts.dart';
import 'package:doni_pizza/utils/dialogs/snackbar_dialogs.dart';
import 'package:doni_pizza/utils/fonts/fonts.dart';
import 'package:doni_pizza/utils/icons.dart';
import 'package:doni_pizza/utils/logging/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthUserState>(
        listener: (context, state) {
          if (state.signInWithGoogleStatus == Status.success) {
            TLoggerHelper.info("Success");
            // final userDataCubit = context.read<UserDataCubit>().state;
            // final userUid = FirebaseAuth.instance.currentUser!.uid;
            // UserRepository().storeUserData(UserModel(id: userUid, name: userDataCubit.name, phoneNumber: userDataCubit.phoneNumber, email: ''));
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
    return Container(
      height: context.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              image: CachedNetworkImageProvider(
                  'https://images.unsplash.com/photo-1520201163981-8cc95007dd2a?q=80&w=2736&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'))),
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Gap(kToolbarHeight * 2),
                SizedBox(
                    height: 143,
                    child: Center(
                      child: Text(LocaleKeys.login.tr(),
                          style: TFonts.titleScreen.copyWith(color: Colors.white)),
                    )),
                const Gap(TSizes.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.all(TSizes.sm)),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TSizes.lg),
                            side: const BorderSide(color: Colors.black, width: 2)))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // context.read<AuthBloc>().add(LoginEvent(
                        //     phoneNumber:
                        //     TFormatter.convertPhoneNumberToEmail(_phoneController.text.trim()),
                        //     name: _nameController.text.trim()));
                        context.read<AuthBloc>().add(GoogleLoginEvent());
                      }
                    },
                    label:  Text(
                      LocaleKeys.continue_with_google.tr(),
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'Sora', fontWeight: FontWeight.bold),
                    ),
                    icon: BlocConsumer<AuthBloc, AuthUserState>(builder: (context, state) {
                      if (state.signInWithGoogleStatus == Status.loading) {
                        return const SizedBox.square(
                            dimension: TSizes.sm,
                            child: CircularProgressIndicator(color: AppColors.black));
                      }
                      return SvgPicture.asset(AppImages.google);
                    }, listener: (BuildContext context, AuthUserState state) {
                      if (state.error != null) {
                        TDialog.showAlert(context: context, message: state.error!);
                      }
                    }),
                  ),
                ),
                const Gap(TSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                        child: Divider(
                      endIndent: 16,
                      color: Colors.grey,
                    )),
                    Text(
                      LocaleKeys.or.tr(),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora'),
                    ),
                    const Expanded(
                        child: Divider(
                      indent: 16,
                      color: Colors.grey,
                    )),
                  ],
                ),
                const Gap(TSizes.md),
                RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(
                        text: LocaleKeys.do_not_have_an_account.tr(),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Sora',
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                          text: ' ${LocaleKeys.signUp.tr()}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Sora',
                              fontSize: 15,
                              fontWeight: FontWeight.bold))
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
