import 'package:doni_pizza/data/models/user_model.dart';
import 'package:doni_pizza/data/repositories/user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doni_pizza/data/repositories/auth_repo.dart';
import 'package:doni_pizza/utils/formatters/formatter.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthUserState> {
  final AuthRepository authRepository;
  final UserRepository userRepository = UserRepository();

  AuthBloc(this.authRepository) : super(const AuthUserState()) {
    on<LoginEvent>((_signInWithEmailAndPassword));
    on<GoogleLoginEvent>(_signInWithGoogle);
    on<RegisterWithGoogleEvent>(registerWithGoogle);
    // on<RegisterEvent>(_registerWithEmailAndPassword);
    on<UpdateUserDataEvent>(_updateUserData);
  }

  void _updateUserData(UpdateUserDataEvent event, Emitter<AuthUserState> emit) async {
    emit(state.copyWith(userDataUpdateStatus: Status.loading));
    try {
      final userModel = await userRepository.updateUserData(event.name, event.phoneNumber);
      emit(state.copyWith(userDataUpdateStatus: Status.success, userModel: userModel));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), userDataUpdateStatus: Status.failure));
    }
  }

  void registerWithGoogle(RegisterWithGoogleEvent event, Emitter<AuthUserState> emit) async {
    emit(state.copyWith(registerWithEmailAndPasswordStatus: Status.loading));
    try {
      final user = await authRepository.registerWithGoogle();
      emit(state.copyWith(user: user, registerWithEmailAndPasswordStatus: Status.success));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), registerWithEmailAndPasswordStatus: Status.failure));
    }
  }

  void _signInWithGoogle(GoogleLoginEvent event, Emitter<AuthUserState> emit) async {
    emit(state.copyWith(signInWithGoogleStatus: Status.loading));
    try {
      final user = await authRepository.signInWithGoogle();
      emit(state.copyWith(user: user, signInWithGoogleStatus: Status.success));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), signInWithGoogleStatus: Status.failure));
    }
  }

  void _signInWithEmailAndPassword(LoginEvent event, emit) async {
    emit(state.copyWith(signInWithEmailAndPasswordStatus: Status.loading));
    try {
      final user = await authRepository.signInWithEmailAndPassword(
          TFormatter.convertPhoneNumberToEmail(event.phoneNumber), event.name);

      emit(state.copyWith(user: user, signInWithEmailAndPasswordStatus: Status.success));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), signInWithEmailAndPasswordStatus: Status.failure));
    }
  }

// void _registerWithEmailAndPassword(RegisterEvent event, emit) async {
//   emit(state.copyWith(registerWithEmailAndPasswordStatus: Status.loading));
//   try {
//     final user = await authRepository.registerWithEmailAndPassword(
//         TFormatter.convertPhoneNumberToEmail(event.phoneNumber), event.password);
//     await userRepository.storeUserData(UserModel(
//       id: user!.uid,
//       name: event.name,
//       phoneNumber: event.phoneNumber,
//       imageUrl: '',
//     ));
//     emit(state.copyWith(user: user, registerWithEmailAndPasswordStatus: Status.success));
//   } catch (e) {
//     emit(state.copyWith(error: e.toString(), registerWithEmailAndPasswordStatus: Status.failure));
//   }
// }
}
